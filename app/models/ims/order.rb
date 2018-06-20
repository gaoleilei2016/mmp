#encoding:utf-8
# => 药店-订单
# => 状态 status (A=>"待交费",P=>"待发药",E=>"已发药",C=>"已退药",S=>"已过期",O=>'取消/作废','T'=>"终止/暂停/中断")
class Ims::Order < ApplicationRecord
	
  class << self

  	# 订单查询()
  	def order_search args={}
      begin
        data = []
        return {flag:false,:info=>"药店机构为空。"} if args[:org_id].blank?
        # sql =" SELECT * FROM orders_orders where target_org_id = #{args[:org_id]}"
        query ="select * from orders_orders where target_org_id = #{args[:org_id]}"
        query.concat(" and order_code=#{args[:order_code]}") unless args[:order_code].blank?
        case  args[:type].to_s
        when '1'#未付款
         query.concat(" and payment_type = 2 and status=1 ")
        when '2'#已付款
         query.concat(" and status=2 ")
        when '5'#已发药
         query.concat(" and status=5 ")
        when '7'#已退药
         query.concat(" and status=7 ")
        else
        end
        query.concat(' order by created_at desc')
        # query.concat(" and status =#{ args[:type].to_s}")
        Orders::Order.find_by_sql(query).map{|order| 
          preson = Person.find order.person_id rescue nil
          data <<{
          order_id: order.id,
          order_code: order.order_code,
          amt: order.net_amt,
          status: order.status,
          payment_at: order.payment_at,     # 支付时间
          end_time: order.end_time,     # 订单完成时间
          close_time: order.close_time,
          target_org_name: order.target_org_name,
          source_org_name: order.source_org_name,
          doctor: order.doctor,
          prescriptions_id: order.prescription_ids,
          prescriptions_count: order.try(:prescription_ids).count,
          patient_name: order.patient_name,
          patient_sex: order.patient_sex,
          patient_age: order.patient_age,
          patient_iden: order.patient_iden,
          patient_phone: order.patient_phone,
          payment_type: order.payment_type,
          is_returned: order.is_returned,
          }
        }
        return {flag:true,data:data}
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 订单发药 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
  	end

  	# 未指定药店的订单查询(未在平台上操作的患者也能在药店客户端协助患者自选药品购药)[可能查到]
    def get_prescription_or_order_data args = {}
      i_days = 6
      attrs = {search:args[:search],i_days:i_days,org_id:args[:org_id]}
      data = Ims::GetData.find_data attrs
      p "=============================="
      p data
      # result = data.map{|e| e.deep_symbolize_keys}
      # result[0]["r_status"]=="-1" ? result : result.group_by{|e| {:r_status=>e[:r_status], :r_info=>e[:r_info], :cfid=>e[:cfid], :iden=>e[:iden], :name=>e[:name], :phone=>e[:phone], :age=>e[:age], :gender_display=>e[:gender_display], :address=>e[:address], :unit_name=>e[:unit_name], :hospital_oid=>e[:hospital_oid], :hospital_name=>e[:hospital_name], :organization_id=>e[:organization_id], :cfstatus=>e[:cfstatus]}} 
      # result = data[0].deep_symbolize_keys
    end

    # 已发已退药订单查询
    # args = {org_id:org_id,search:search}
    def get_order_by_code args={}
      begin
        return {flag:false,:info=>"药店机构为空。"} if args[:org_id].blank?
        order_code = args[:search]
        query ="target_org_id = #{args[:org_id]} and (status = 5  or (status = 7))"
        query.concat(" and order_code=#{order_code}") unless order_code.blank?
        orders = Orders::Order.where(query)
        return {flag:false,:info=>"未找到订单信息"} if orders.count==0
        order = orders.last 
        result = get_order_data order
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 已发已退药订单查询 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end

    # 订单明细信息及处方信息查询
    def get_order args={}
      begin
        return {flag:false,:info=>"药店机构为空。"} if args[:org_id].blank?
        order = Orders::Order.find args[:order_id] rescue nil #and target_org_id = #{args[:org_id]}
        return {flag:false,:info=>"未找到订单信息"} if order.blank?
        return {flag:false,:info=>"该订单为#{order.target_org_name}的订单。"} if order.target_org_id!=args[:org_id]
        result = get_order_data order
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 订单明细信息及处方信息查询 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end

    # 处方信息
    def get_order_data order 
      return {flag:false,:info=>"未找到订单信息"} if order.blank?
      prescriptions = ::Hospital::Interface.get_prescriptions_by_ids(order.prescription_ids)
      data = {
          type:'订单',
          is_order:true,
          order_id: order.id,
          order_code: order.order_code,
          amt: order.net_amt,
          status: order.status,
          payment_at: order.payment_at,     # 支付时间
          created_at: order.created_at,     # 订单生成时间
          end_time: order.end_time,     # 订单完成时间
          close_time: order.close_time,
          target_org_name: order.target_org_name,
          source_org_name: order.source_org_name,
          doctor: order.doctor,
          prescriptions_id: order.prescription_ids,
          prescriptions_count: order.try(:prescription_ids).count,
          patient_name: order.patient_name,
          patient_sex: order.patient_sex,
          patient_age: order.patient_age,
          patient_iden: order.patient_iden,
          patient_phone: order.patient_phone,
          payment_type: order.payment_type,
          is_returned: order.is_returned,
          details: order.details.map{|x| {
                  name: x.name,
                  quantity: x.quantity,
                  unit: x.unit,
                  specifications: x.specifications,
                  dosage: x.dosage,
                  price: x.price,
                  net_amt: x.net_amt,
                  firm: x.firm,
                  img_path: x.img_path
                }
              },
          pres:[]
        }
          p "++++++++++++++++++++++++++"
          p prescriptions
          p "++++++++++++++++++++++++++"
          temp = 0;    
          prescriptions.each do |k,v|
            p "---------------------",v
            next if v[:orders].blank?
            details = v[:orders].map{|x| {
                    name: x[:title],
                    specifications: x[:specification],
                    quantity: x[:total_quantity],
                    unit: x[:unit],
                    price: x[:price],
                    net_amt: (x[:total_quantity].to_f*x[:price].to_f),
                    firm:x[:firm],
                    frequency:x[:frequency][:display],
                    dose:x[:dose][:value].to_s + x[:dose][:unit].to_s,
                    route:x[:route][:display]
                  }
                }
            data[:pres] <<{
              :type => '处方'+(temp += 1).to_s,
              :is_order => false,
              :order_id => "",
              :order_code => v[:prescription_no],
              :amt => v[:price],
              :status => v[:status],
              :phone=>v[:phone],
              :source_org_name => v[:org][:display],
              :doctor => v[:author][:display],
              :prescription_id => v[:id],
              :patient_name => v[:name],
              :patient_sex => v[:gender][:display],
              :patient_age => v[:age],
              :patient_iden => v[:iden],
              :patient_phone => v[:phone],
              :payment_type => v[:payment_type],
              :address => v[:address],
              :patient_no => v[:patient_no],
              :encounter_loc => v[:encounter_loc][:display],
              :note => v[:note],
              :pre_type => v[:type][:display],
              :diagnoses => ((v[:diagnoses]||[]).map{|e| e.display}.join(",") rescue nil),
              :created_at => v[:created_at],
              details: details
            }
          end
        return {flag:true,:order=>data}
    end

    # 到店患者未在平台操作的处方收费或者收费并发药操作
    # => args = {org_id:org_id,org_name:org_name,prescription_ids:prescription_ids,status:status,user_id:user_id,user_name:user_name}
    def operat_order_by_prescription args = {}
      begin
        p "----------------",args
        return {flag:false,:info=>"药店机构为空。"} if args[:org_id].blank?
        attrs = {pharmacy_id:args[:org_id],pharmacy_name:args[:org_name],user_name:args[:user_name],user_id:args[:user_id],prescription_ids:args[:prescription_ids],payment_type:"2",status:'2',current_user:args[:current_user]}
        ::ActiveRecord::Base.transaction  do
          case args[:status]
          when '2'
            result = Orders::Order.create_order_by_presc_ids attrs
            return (result[:ret_code]=="0" ? {flag:false,:info=>"处方收费处理成功！"} : {flag:false,:info=>"处方收费处理失败。",result:result})
          when '5'
            result = Orders::Order.create_order_by_presc_ids attrs
            return {flag:false,:info=>"处方收费处理失败。",result:result} unless result[:ret_code]=="0"
            order = result[:order]
            att = {id:order.id,drug_user:args[:user_name],drug_user_id:args[:user_id],current_user:args[:current_user],status:'5'}
            order_com = Orders::Order.order_completion att
            pre_data = dispensing_order att
            return pre_data[:flag] ? {flag:true,info:"处方发药成功！",order_com:order_com} : {flag:false,info:"处方发药失败。",order_com:order_com,pre_data:pre_data}
          else
            return {flag:false,:info=>"处方暂不做处理。"}
          end
        end
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 到店患者未在平台操作的处方收费或者收费并发药操作 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end

    # 退药
    def return_drug1 args={}
      begin
        order_id = args[:id]
        order = Orders::Order.find order_id rescue nil
        return {flag:false,:info=>"未找到订单信息。"} if order.blank?
        # return {flag:false,:info=>"线上支付订单不能退药。"} if order.payment_type!="2"
        return {flag:false,:info=>"该订单为#{order.target_org_name}的订单。"} if order.target_org_id!=args[:org_id]
        return {flag:false,:info=>"该订单已退药，不能再次退药。"} if order.is_returned==1
        return {flag:false,:info=>"该订单已发药，不能退药。"} if order.status!="5"
        order.update_attributes(is_returned:true,reason:args[:reason])
        new_order = order.clone.dup
        new_order.order_code = order.order_code.to_s+"_T"
        new_order.ori_id = order.id
        new_order.ori_code = order.order_code
        new_order.returner = args[:user_name]
        new_order.returner_id = args[:user_id]
        new_order.return_at = Time.new
        new_order.prescriptions = order.prescriptions
        new_order.status = '7'
        order.details.each do |detail|
          dup_detail = detail.clone.dup
          dup_detail.quantity = -detail.quantity.to_f
          dup_detail.net_amt = -detail.net_amt.to_f
          dup_detail.ori_detail_id = detail.id
          dup_detail.save
          new_order.details << dup_detail
        end
        new_order.save ? {flag:true,info:'退药成功！'} : {flag:false,info:'退药失败。',}
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 退药 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end

    # 发药
    def dispensing_order args = {}
      order_id = args[:id]
      current_user = args[:current_user]
      order = Orders::Order.find order_id rescue nil
      return {flag:false,:info=>"未找到订单信息。"} if order.blank?
      return {flag:false,:info=>"未查到发药用户信息。"} if current_user.blank?
      return {flag:false,:info=>"该订单为#{order.target_org_name}的订单。"} if order.target_org_id!=current_user.organization_id
      return {flag:false,:info=>"该订单已退药，不能再次发药。"} if order.is_returned==1
      return {flag:false,:info=>"该订单已发药，不能再次发药。"} if order.status=="5"
      ::ActiveRecord::Base.transaction  do
        temp = {id:args[:id],drug_user:current_user.name,drug_user_id:current_user.id,current_user:current_user,status:"5"}
        data = Orders::Order.order_completion(temp)
        return {flag:false,info:data[:info]} if data[:ret_code].to_i!=0
        prescriptions = ::Hospital::Interface.get_prescriptions_by_ids(order.prescription_ids)
        send_data = {current_user:current_user,prescriptions:prescriptions}
        result = Ims::PrescriptionHeader.save_prescription send_data
        return_data = result[:flag] ? {flag:true,info:'退药成功！'} : {flag:false,info:(result[:flag]|| '退药失败。')}
      end
      return_data
    end

    # 退药
    def return_drug args={}
      begin
        pre_id = args[:id]
        header = Ims::PrescriptionHeader.find pre_id rescue nil
        return {flag:false,:info=>"未找到处方信息。"} if header.blank?
        # return {flag:false,:info=>"线上支付订单不能退药。"} if header.payment_type!="2"
        return {flag:false,:info=>"该处方为#{header.delivery_org_name}的发药处方，请前往该药店进行退药。"} if header.delivery_org_id!=args[:org_id]
        return {flag:false,:info=>"该处方已退药，不能再次退药。"} if header.is_returned==1
        return {flag:false,:info=>"该处方不是发药状态，不能退药。"} if header.status!="5"
        current_user = args[:current_user]
        ::ActiveRecord::Base.transaction  do
          update_data = {return_id:current_user.id,return_name:current_user.name,return_org_id:current_user.organization_id,return_org_name:current_user.organization.name,return_at:Time.new,is_returned:true,reason:args[:reason]}
          result = header.update_attributes!(update_data)
        end
        result ? {flag:true,info:'退药成功！'} : {flag:false,info:(result[:flag]|| '退药失败。'),}
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 退药 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end

    # 下载错误处方返回
    def prescription_back args = {}
      begin
        
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 下载错误处方返回 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end

    def send_message attrs
      NoticeBroadcastJob.perform_later notice:"这是一段测试信息"
    end

    def order_message attrs
      p "modal   hahahahha"
      p attrs
      # NoticeBroadcastJob.perform_later notice:"这是一段测试信息"
      # ActionCable.server.broadcast 'notice_channel', jobs:"sdfasd"
      NoticeBroadcastJob.perform_later notice:"这是一段测试信息"
    end

  end
end

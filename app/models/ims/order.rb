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
        query ="target_org_id = #{args[:org_id]}"
        query.concat(" and order_code=#{args[:order_code]}") unless args[:order_code].blank?
        case  args[:type].to_s
        when '1'#未付款
         query.concat(" and payment_type = 2 and `status`=1 ")
        when '2'#已付款
         query.concat(" and `status`=2 ")
        when '5'#已发药
         query.concat(" and `status`=5 ")
        when '7'#已退药
         query.concat(" and `status`=7 ")
        else
        end

        p query
        # query.concat(" and status =#{ args[:type].to_s}")
        Orders::Order.where(query).map{|order| 
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
      p "]]]]]]]]]]]]]]]]]]]]]]]]]]]"
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
        p orders.count
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
      data = [{
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
              }
          }]
          
          temp = 0;         
          prescriptions.each{|key,line| data<<{
            type:'处方'+(temp += 1).to_s,
            is_order:false,
            order_id: line[:id],
            order_code: line[:prescription_no],
            amt: line[:price],
            status: line[:status],
            payment_at: line[:payment_at],     # 支付时间
            created_at: line[:created_at].try(:to_s,:db),     # 订单生成时间
            end_time: line[:end_time],     # 订单完成时间
            close_time: line[:close_time],
            target_org_name: line[:target_org_name],
            source_org_name: line[:source_org_name],
            doctor: line[:author][:display],
            prescriptions_id: line[:prescription_ids],
            prescriptions_count: line[:prescription_ids].try(:count),
            patient_name: line[:name],

            patient_sex: line[:gender_display],
            patient_age: line[:age],
            patient_iden: line[:iden],
            
            patient_phone: line[:patient_phone],
            payment_type: line[:payment_type],
            details: (line[:orders]||[]).map{|x| {
                    name: x[:title],
                    specifications: x[:specification],
                    quantity: x[:total_quantity],
                    unit: x[:unit],
                    dosage: x[:dosage],
                    price: x[:price],
                    net_amt: x[:net_amt],
                    firm: x[:firm],
                    img_path: x[:img_path]
                  }
                }
            }
        }

        return {flag:true,:data=>data}
    end

    # 到店患者未在平台操作的处方收费或者收费并发药操作
    # => args = {org_id:org_id,org_name:org_name,prescription_ids:prescription_ids,status:status,user_id:user_id,user_name:user_name}
    def operat_order_by_prescription args = {}
      begin
        return {flag:false,:info=>"药店机构为空。"} if args[:org_id].blank?
        attrs = {pharmacy_id:args[:org_id],pharmacy_name:args[:org_name],prescription_ids:args[:prescription_ids],payment_type:"2",status:'2'}
        ::ActiveRecord::Base.transaction  do
          case args[:status]
          when '2'
            result = Orders::Order.create_order_by_presc_ids attrs
            return (result[:ret_code]="0" ? {flag:false,:info=>"处方收费处理成功！"} : {flag:false,:info=>"处方收费处理失败。",result:result})
          when '5'
            result = Orders::Order.create_order_by_presc_ids attrs
            return {flag:false,:info=>"处方收费处理失败。",result:result} unless result[:ret_code]="0"
            order = result[:order]
            att = {id:order.id,drug_user:args[:user_name],drug_user_id:args[:user_id]}
            order_com = Orders::Order.order_completion att
            return (result[:ret_code]="0" ? {flag:true,info:"处方发药成功！"} : {flag:false,:info=>"处方发药失败。",result:result,order_com:order_com})  
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
    def return_drug args={}
      begin
        order_id = args[:order_id]
        order = Orders::Order.find order_id rescue nil
        return {flag:false,:info=>"未找到订单信息"} if order.blank?
        return {flag:false,:info=>"该订单为#{order.target_org_name}的订单。"} if order.target_org_id!=args[:org_id]
        order.update_attributes(is_returned:true)
        new_order = order.clone
        new_order.order_code = order.order_code.to_s+"_T"
        new_order.ori_id = order.id
        new_order.ori_code = order.order_code
        new_order.drug_user = args[:user_name]
        new_order.drug_user_id = args[:user_id]
        new_order.prescriptions = order.prescriptions
        new_order.status = '7'
        order.details.each do |detail|
          dup_detail = detail.clone
          dup_detail.quantity = -detail.quantity.to_f
          dup_detail.net_amt = -detail.net_amt.to_f
          dup_detail.ori_detail_id = detail.id
          new_order.details << Orders::OrderDetail.create(dup_detail)
        end
        Orders::Order.create(new_order) ? {flag:true,info:'退药成功！'} : {flag:false,info:'退药失败。',}
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

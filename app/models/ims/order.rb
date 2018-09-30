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
         query.concat(" and is_send_medical>=1 and status=7 ")
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
          # is_returned: order.is_returned,
          created_at: order.created_at,
          }
        }
        return {flag:true,data:data}
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 订单发药 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
  	end

    # 处方查询(已发药、退药)
    def prescription_search args={}
      begin
        data = []
        return {flag:false,:info=>"药店机构为空。"} if args[:org_id].blank?
        query ="select * from ims_prescription_headers where delivery_org_id = #{args[:org_id]}"
        query.concat(" and prescription_no=#{args[:order_code]}") unless args[:order_code].blank?
        query.concat(" and status=#{args[:status]}")
        case args[:status].to_i
        when 4
          query.concat(" order by delivery_at desc")
        when 8
          query.concat(" order by return_at desc")
        else
        end
        Ims::PreHeader.find_by_sql(query).map{|header|
          data <<{
            order_id:header.id,
            prescription_no:header[:prescription_no],
            name:header[:name],
            total_amount:header[:total_amount],
            delivery_at:header[:delivery_at],
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

    # 获取处方信息
    def get_prescription args = {}
      p "===========================",args
      return {flag:false,:info=>"药店机构为空。"} if args[:org_id].blank?
      header = Ims::PreHeader.find args[:prescription_id] rescue nil #and target_org_id = #{args[:org_id]}
      return {flag:false,:info=>"未找到处方信息"} if header.blank?
      return {flag:false,:info=>"该处方为#{header.delivery_org_name}的处方。"} if header.delivery_org_id.to_s!=args[:org_id].to_s
      return {flag:false,:info=>"未找到处方明细信息"} if header.details.blank?
      data = {
          # :type => '处方'+(temp += 1).to_s,
          :is_order => false,
          :order_id => header.id,
          :order_code => header.prescription_no,
          :amt => header.total_amount,
          :status => header.status,
          :phone=>header.phone,
          :source_org_name => header.org_display,
          :doctor => header.author_display,
          :prescription_id => header.id,
          :patient_name => header.name,
          :patient_sex => header.gender_name,
          :patient_age => header.age,
          :patient_iden => header.iden,
          :patient_phone => header.phone,
          # :payment_type => header.payment_type,
          :address => header.address,
          :patient_no => header.patient_no,
          :encounter_loc => header.encounter_loc_display,
          :note => header.note,
          :pre_type => header.type_name,
          :diagnoses => ((header.diagnoses||[]).map{|e| e.display}.join(",") rescue nil),
          :created_at => header.created_at,
          :delivery_id => header.delivery_id,
          :delivery_name => header.delivery_name,
          :delivery_at => header.delivery_at,
          :invoice_id => header.invoice_id,
          # :is_returned => header.is_returned,
          details: (header.details||[]).map{|x| {
                    title: x.title,
                    specification: x.specification,
                    :dose_value=>x.dose_value,
                    :dose_unit=>x.dose_unit,
                    :route_display=>x.route_display,
                    :frequency_code=>x.frequency_code,
                    :frequency_display=>x.frequency_display,
                    :course_of_treatment_value=>x.course_of_treatment_value,
                    :course_of_treatment_unit=>x.course_of_treatment_unit,
                    :formul_code=>x.formul_code,
                    :formul_display=>x.formul_display,
                    :qty=>x.qty,
                    :unit=>x.unit,
                    :price=>x.price,
                    :amount=>x.amount,
                    :note=>x.note,
                    :status=>x.status,
                  }
                }
        }
      return {flag:true,:order=>data}
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

    # 订单及处方明细信息
    def get_order_data order 
      return {flag:false,:info=>"未找到订单信息"} if order.blank?
      prescriptions = ::Hospital::Interface.get_prescriptions_by_ids(order.prescription_ids)
      fp = ::Customer::InvoiceHeader.find order.invoice_id rescue nil
      invoice = fp.blank? ? {flag:false} : {flag:true,name:fp.name,shuihao:fp.shuihao}
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
          # is_returned: order.is_returned,
          invoice:invoice,
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
          temp = 0;    
          prescriptions.each do |k,v|
            next if v[:orders].blank?
            details = v[:orders].map{|x| {
                    name: x[:title],
                    specifications: x[:specification],
                    quantity: x[:total_quantity],
                    unit: x[:unit],
                    price: x[:price],
                    net_amt: (x[:total_quantity].to_f*x[:price].to_f),
                    firm:x[:factory_name],
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
        p "------operat_order_by_prescription----------",args
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


    # 退药(根据订单退药)
    def return_drug args={}
      begin
        order_id = args[:id]
        current_user = args[:current_user]
        order = Orders::Order.find order_id rescue nil
        order.with_lock do
          return {flag:false,:info=>"未找到订单信息。"} if order.blank?
          # return {flag:false,:info=>"线上支付订单不能退药。"} if order.payment_type!="2"
          return {flag:false,:info=>"该订单为#{order.target_org_name}的订单。"} if order.target_org_id.to_s!=args[:org_id].to_s
          return {flag:false,:info=>"该订单不是发药状态，不能退药。"} if order.status.to_i!=5
          return {flag:false,:info=>"该订单已退药，不能再次退药。"} if (order.status.to_i==7)
          headers = Ims::PreHeader.where("order_id=#{order_id} and delivery_org_id=#{args[:org_id]} and status=4 and is_returned is null")
          headers.map{|header| create_new_prescription header,current_user,args}
          # is_returned:true,
          headers.update_all({is_returned:true,reason:args[:reason],return_name:current_user.name,return_id:current_user.id,return_org_id:current_user.organization_id,return_org_name:current_user.organization.try(:id),return_at:Time.new})
          attrs = {prescription_ids:headers.distinct(:id),current_user:current_user,reason:(args[:reason]||'退药')}
          order.cancel_medical(attrs)
          {flag:true,info:'退药成功！'}
        end
      rescue ActiveRecord::StaleObjectError => e
        print e.message rescue "  e.messag----"
        print "=== dispensing_order ============ 退药乐观锁 出错: " + e.backtrace.join("\n")
        {flag:false,info:'该单退药中，不用重复退药。'}
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 退药 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end

    # 退费(根据订单退药)
    def return_amount args={}
      begin
        order_id = args[:id]
        current_user = args[:current_user]
        order = Orders::Order.find order_id rescue nil
        return {flag:false,:info=>"未找到订单信息。"} if order.blank?
        # return {flag:false,:info=>"线上支付订单不能退药。"} if order.payment_type!="2"
        return {flag:false,:info=>"该订单为#{order.target_org_name}的订单。"} if order.target_org_id.to_s!=args[:org_id].to_s
        return {flag:false,:info=>"该订单不是收费状态，不能退费。"} if order.status.to_i!=2
        return {flag:false,:info=>"该订单不是线下订单，不能退费。"} if order.payment_type.to_i!=2
        return {flag:false,:info=>"该订单已发药，不能退费。"} if (order.status.to_i==5||order.status.to_i==6||order.status.to_i==7)
        headers = Ims::PreHeader.where(:order_id=>order_id,delivery_org_id:args[:org_id])
        attrs = {prescription_ids:headers.distinct(:id),current_user:current_user,reason:(args[:reason]||'退费')}
        result = order.cancel_medical(attrs)
        {flag:true,info:'退费成功！'}
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 退费 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end

    # 发药
    def dispensing_order args = {}
      begin
        result = {}
        order_id = args[:id]
        current_user = args[:current_user]
        order = Orders::Order.find order_id rescue nil
        order.with_lock do
          return {flag:false,:info=>"未找到订单信息。"} if order.blank?
          return {flag:false,:info=>"未查到发药用户信息。"} if current_user.blank?
          return {flag:false,:info=>"该订单为#{order.target_org_name}的订单。"} if order.target_org_id!=current_user.organization_id
          # return {flag:false,:info=>"该订单已退药，不能再次发药。"} if order.is_returned==1
          return {flag:false,:info=>"该订单已发药，不能再次发药。"} if order.status=="5"
          # ::ActiveRecord::Base.transaction  do
            # ============ 判断表是否存，不存在则创建 ====================
            # org_id = current_user.organization_id
            # t_name = 'IPH_' + org_id.to_s
            # td_name = 'IPD_' + org_id.to_s
            # t_exist = table_name_exist t_name
            # create_copy_table t_name,td_name unless t_exist
            # ================================
            prescriptions = ::Hospital::Interface.get_prescriptions_by_ids(order.prescription_ids)
            send_data = {current_user:current_user,prescriptions:prescriptions,order:order}
            result = Ims::PreHeader.save_prescription send_data
            return {flag:false,info:"发药失败: #{result[:info]}"} unless result[:flag]
            send_ar =[] 
            result[:prescription_headers].each do |header|
              send_ar = header.details.map{|detail| {:medicine_id=>detail.drug_id,:location_id=>current_user.organization_id,:qty=>(-detail.qty.to_f),:batch=>nil,:price=>detail.price.to_f,:stock_id=>nil}}
            end
            pre_posting send_ar
            temp = {id:args[:id],drug_user:current_user.name,drug_user_id:current_user.id,current_user:current_user,status:"5"}
            data = Orders::Order.order_completion(temp)
            data = {ret_code:0}
          # end
          return_data = data[:ret_code]==0 ? {flag:true,info:'发药成功！'} : {flag:false,info:"发药失败。"}
        end
      rescue ActiveRecord::StaleObjectError => e
        print e.message rescue "  e.messag----"
        print "=== dispensing_order ============ 发药乐观锁 出错: " + e.backtrace.join("\n")
        {flag:false,info:'该单发药中，不用重复发药。'}
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "=== dispensing_order ============ 发药 出错: " + e.backtrace.join("\n")
        {flag:false,info:'发药失败。'}
      end
    end

    # 退药(根据处方退药)
    def return_drug1 args={}
      begin
        pre_id = args[:id]
        header = Ims::PreHeader.find pre_id rescue nil
        # order_id = args[:id]
        # header = Orders::Order.find order_id rescue nil
        return {flag:false,:info=>"未找到处方信息。"} if header.blank?
        # return {flag:false,:info=>"线上支付处方不能退药。"} if header.payment_type!="2"
        return {flag:false,:info=>"该处方为#{header.target_org_id}的发药处方，请前往该药店进行退药。"} if header.target_org_id.to_s!=args[:org_id].to_s
        # return {flag:false,:info=>"该处方已退药，不能再次退药。"} if header.is_returned==1
        return {flag:false,:info=>"该处方不是发药状态，不能退药。"} if header.status.to_s!="4"
        current_user = args[:current_user]
        update_data = {return_id:current_user.id,return_name:current_user.name,return_org_id:current_user.organization_id,return_org_name:current_user.organization.name,return_at:Time.new,reason:args[:reason]}
        # update_data = {return_id:current_user.id,return_name:current_user.name,return_org_id:current_user.organization_id,return_org_name:current_user.organization.name,return_at:Time.new,is_returned:true,reason:args[:reason]}
        result = header.update_attributes!(update_data)
        return {flag:false,info:'退药失败。'} unless result
        header.reload
        header.details.map{|e| e.update_attributes!(return_qty:e.send_qty)}
        create_new_prescription header,current_user,args
        attrs = {prescription_ids:[header.id],current_user:current_user,reason:(args[:reason]||'退药')}
        # Orders::Order.find(header.bill_id).cancel_medical(attrs)
        {flag:true,info:'退药成功！'} #: {flag:false,info:(result[:info]|| '退药失败。'),}
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 退药 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end

    def create_new_prescription header = {},current_user,args
      begin
        new_header = header.clone.dup
        # new_header.prescription_no = header.prescription_no.to_s+"_T"
        org_id = current_user.organization_id
        org_name = current_user.organization.try(:name)
        new_header.ori_id = header.id
        new_header.ori_code = header.prescription_no
        new_header.return_name = current_user.name
        new_header.return_id = current_user.id
        new_header.return_org_id = org_id
        new_header.return_org_name = org_name
        new_header.reason = args[:reason]
        new_header.return_at = Time.new
        new_header.total_amount = -header.total_amount.to_f
        new_header.status = '8'
        details,send_ar = [],[]
        header.details.each do |detail|
          dup_detail = detail.clone.dup
          dup_detail.qty = -detail.qty.to_f
          dup_detail.amount = -detail.amount.to_f
          dup_detail.return_qty = detail.qty.to_f
          dup_detail.ori_detail_id = detail.id
          dup_detail.status = '8'
          dup_detail.header_id = nil
          details << dup_detail.attributes
          send_ar << {:medicine_id=>detail.drug_id,:location_id=>org_id,:qty=>detail.qty.to_f,:batch=>nil,:price=>detail.price.to_f,:stock_id=>nil}
        end
        pre_posting send_ar
        return {flag:false,info:'该处方已退过药，不能再次退药。'} if ::Ims::PreHeader.where(ori_id:header.id).count>0
        details_1 = Ims::PreDetail.create!(details)
        new_header.details = details_1
        new_header.save! ? {flag:true,info:'退药保存成功！'} : {flag:false,info:'退药保存失败。'}
      rescue Exception => e
        print e.message 
        print "+++++++++++++++++++++++ create_new_prescription 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end


    # 过账方法(发药减少库存、退药增加库存)
    # （药品ID、药库ID、数量、批号、单价）
    def pre_posting  attrs = []
      begin
        runsql=ActiveRecord::Base.connection()
        attrs.each do |args|
          medicine_id = args[:medicine_id]
          location_id = args[:location_id]
          qty = args[:qty]
          batch = args[:batch]
          price = args[:price]
          stock_id = args[:stock_id]
          result = Ims::Inv::Stock.find(stock_id) rescue nil
          if result.blank?
            sql = "SELECT * FROM ims_inv_stocks s WHERE s.medicine_id=#{medicine_id} and s.location_id = #{location_id} and s.price = #{price.to_f.round(4)}"
            sql.concat("and s.batch=#{batch}") if !batch.blank?
            # sql.concat(" and source_org_id=#{args[:source_org_id]}") unless args[:source_org_id].blank?
            res = Ims::Inv::Stock.find_by_sql(sql)
            stock_id = res[0].try(:id)
            result = Ims::Inv::Stock.find(stock_id) rescue nil
          end
          if !result.blank?
            amount = (qty.to_f*price.to_f.round(2))
            update_sql = "update ims_inv_stocks set quantity = quantity+#{qty.to_f},amount=amount+#{amount} where id = #{stock_id}"
            runsql.update update_sql
          end 
          # find_sql = "select * from dis"
        end
        p "ffffffffffffffffffffff 过账方法 ffffffffff"
        {flag:true,info:"OK ! OK ! OK !"} 
      rescue Exception => e
        p "qqqqqqqqqqqqqqqqqqqqqq 过账方法 qqqqqqqqqqqq"
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 过账方法 出错: " + e.backtrace.join("\n")
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
    
    # 判断表名是否存在
    def table_name_exist org_id
      begin
        return false if org_id.blank?
        t_name = 'iph_'+org_id
        Ims::PreHeader.find_by_sql("show tables like '#{t_name}';").blank? ? create_copy_table(org_id) : true
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 判断表名是否存在 出错: " + e.backtrace.join("\n")
        return false
      end
    end

    # 创建表(复制 ims_per_headers 表结构)
    def create_copy_table org_id
      t_name = 'iph_'+org_id
      td_name = 'ipd_'+org_id
      sql = "CREATE TABLE #{t_name} LIKE ims_per_headers "
      sql_1 = "CREATE TABLE #{td_name} LIKE ims_per_details "
      ActiveRecord::Base.connection.execute sql
      ActiveRecord::Base.connection.execute sql_1
      true
    end


    def send_message attrs
      # NoticeBroadcastJob.perform_later notice:"这是一段测试信息"
    end

    def order_message attrs
      p "modal   hahahahha"
      p attrs
      str = attrs[:message]
      # NoticeBroadcastJob.perform_later notice:"这是一段测试信息"
      # ActionCable.server.broadcast 'notice_channel', data:str
      # NoticeBroadcastJob.perform_later data:str
    end

  end
end

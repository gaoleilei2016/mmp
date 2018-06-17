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
      # i_days = 6
      attrs = {search:args[:search],i_days:i_days,org_id:args[:org_id]}
      data = Ims::GetData.find_data attrs
      result = data.map{|e| e.deep_symbolize_keys}
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


    def get_order_data order 
      return {flag:false,:info=>"未找到订单信息"} if order.blank?
      prescriptions = ::Hospital::Interface.get_prescriptions_by_ids(order.prescription_ids)
      data = [{
          type:'订单',
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
          }, 
          {
            type:'处方',
            prescriptions:prescriptions
          }]
        return {flag:true,:data=>data}
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

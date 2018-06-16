#encoding:utf-8
# => 药店-订单
# => 状态 status (A=>"待交费",P=>"待发药",E=>"已发药",C=>"已退药",S=>"已过期",O=>'取消/作废','T'=>"终止/暂停/中断")
class Ims::Order < ApplicationRecord
	belongs_to :operater, class_name: '::User', foreign_key: 'operater_id', optional: true
	belongs_to :patient_order, class_name: '::Order::Order', foreign_key: 'patient_order_id', optional: true
	# 字段
	# { id: integer, 
	# 	source_org_ii: string, 
	# 	source_org_name: string, 
	# 	target_org_ii: string, 
	# 	target_org_name: string, 
	# 	patient_order_id: string, 
	# 	order_code: string, 
	# 	patient_name: string, 
	# 	repeat_number: integer, 
	# 	total_amount: float, 
	# 	search_name: string, 
	# 	note: string, 
	# 	operater_id: integer, 
	# 	operater_name: string, 
	# 	operat_at: datetime, 
	# 	ori_id: string, 
	# 	ori_code: string, 
	# 	this_returned: boolean, 
	# 	created_at: datetime, 
	# 	updated_at: datetime
	# }


	# 订单发药
  def dispensing_order
  	self.update_attributes(status:"E") ? {flag:true,info:"发药成功！"} : {flag:false,info:"发药失败。"}
  end

  # 订单退药
  def return_order current_user
	  begin
	  	returned_at = Ims::Setting.where(:org_ii=>current_user.try(:org_ii)).try(:returned_at)
	  	return {flag:false,info:"该单已经退过药了。"} if self.this_returned
	  	return {flag:false,info:"退药失败。已超过退药期(#{returned_at})天"} if self.operat_at.to_time<(Time.new-returned_at.to_i)
	  	result = return_order_create current_user
		  self.update_attributes(status:"C") if result[:flag]
		  retrun result
	  rescue Exception => e
	  	print e.message rescue "  e.messag----"
      print "laaaaaaaaaaaaaaaaaaaa 订单退药 出错: " + e.backtrace.join("\n")
      result = {flag:false,:info=>"系统出错。"}
	  end
  end

  # 退药的处方保存
  def return_order_create current_user
  	begin
	  	order_id = BSON::ObjectId.new.to_s
	    lines,ids = [],[]
	    order = self.attributes.deep_symbolize_keys
	    new_code = "T#{self.order_code}"
	    order=order.delete_if {|k,v| (k==:_id || k==:created_at || k==:updated_at || k==:line_ids)}
	    update_data = {operater_id:current_user.try(:id).to_s,operater_name:current_user.try(:name).to_s,operat_at:Time.new,ori_code:self.order_code,ori_id:self.id.to_s,:status=>"C",code:new_code,id:order_id}   #需要更新的字段
	    order.merge!(update_data)
	    h = self.class.create(order)
	    l&&h ? {flag:true,info:"退药成功！"} : {flag:false,info:"退药失败。"}
  	rescue Exception => e
  		print e.message rescue "  e.messag----"
      print "laaaaaaaaaaaaaaaaaaaa 退药的处方保存 出错: " + e.backtrace.join("\n")
      result = {flag:false,:info=>"系统出错。"}
  	end
  end

  # 获取订单明细信息
  def get_order_detail
  	begin
  		self.patient_order
  	rescue Exception => e
  		print e.message rescue "  e.messag----"
      print "laaaaaaaaaaaaaaaaaaaa 获取订单明细信息 出错: " + e.backtrace.join("\n")
      result = {flag:false,:info=>"系统出错。"}
  	end
  	
  end


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
        else
        end
        # query.concat(" and status =#{ args[:type].to_s}")
        Orders::Order.where(query).map{|order| 
          data ={
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


    # 订单明细信息及处方信息查询
  	def get_order args={}
      begin
    		return {flag:false,:info=>"药店机构为空。"} if args[:order_id].blank?
        order = Orders::Order.find args[:order_id] rescue nil #and target_org_id = #{args[:org_id]}
        return {flag:false,:info=>"未找到订单信息"} if order.blank?
        return {flag:false,:info=>"该订单为#{order.target_org_name}的订单。"} if order.target_org_id!=args[:org_id]
        prescriptions = ::Hospital::Interface.get_prescriptions_by_ids(order.prescription_ids)
        data = [{
          type:'订单',
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
            type:'订单',
            prescriptions:prescriptions
          }]
        return {flag:true,:data=>data}
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 订单明细信息及处方信息查询 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
  	end

  	# 订单的接收(接收完订单要发消息，提醒药店)
  	def receive_order args={}
  		begin
  			args = args.deep_symbolize_key
  			order_code = args[:order_code]
  			order = Orders::Order.where(order_code:order_code).last
  			return {flag:true,:info=>"订单的接收失败。"} if order.blank?
  			search_name = ""
  			total_amount = order.details.sum(:net_amt)
  			self.create{{
  				:org_ii => order.target_org_ii,
					:org_name => order.target_org_name,
					:source_org_ii => order.source_org_ii, 
					:source_org_name => order.source_org_name, 
					:target_org_ii => order.target_org_ii, 
					:target_org_name => order.target_org_name, 
					:patient_order_id => order.id.to_s,
					:order_code => order.order_code,
					:patient_name => '',
					:repeat_number => (order.quantity||1),
					:total_amount => total_amount,
					:search_name => search_name,
					:this_returned => false,
  				}}
  			self.create(args)
  			# {flag:true,:info=>"订单的接收成功。"}
  		rescue Exception => e
  			print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 订单的接收 出错: " + e.backtrace.join("\n")
        # {flag:false,:info=>"药店系统出错。"}
        nil
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

#encoding:utf-8
# => 药店-订单
# => 状态 status (A=>"待交费",P=>"待发药",E=>"已发药",=>'退药申请',C=>"已退药",S=>"已过期",O=>'取消/作废','T'=>"终止/暂停/中断")
class Ims::Order < ApplicationRecord
	belongs_to :operater, class_name: '::User', foreign_key: 'operater_id', optional: true
	belongs_to :patient_order, class_name: '::Order::Order', foreign_key: 'patient_order_id', optional: true

	# 订单发药
  def dispensing_order
  	self.update_attributes(status:"E")
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
      print "laaaaaaaaaaaaaaaaaaaa 订单发药 出错: " + e.backtrace.join("\n")
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
      print "laaaaaaaaaaaaaaaaaaaa 订单发药 出错: " + e.backtrace.join("\n")
      result = {flag:false,:info=>"系统出错。"}
  	end
  end


  class << self

  	# 订单查询()
  	def order_search args={}
      begin
        status = args[:status]
        search = args[:search]
        org_ii = args[:org_ii]
        query = {org_ii:org_ii,search_name:/#{search}/i}
        query[:status] = status if status.blank?
    		self.where(query)
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 订单发药 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药房系统出错。"}
      end
  	end

  	# 未指定药房的订单查询(未在平台上操作的患者也能在药店客户端协助患者自选药品购药)[可能查到]
  	def get_order args={}
  		
  	end

  	# 
  	# def method_name
  		
  	# end


  	# 订单的接收(接收完订单要发消息，提醒药房)
  	def receive_order args={}
  		begin
  			args = args.deep_symbolize_key
  			order = args[:order_code]
  			



  			patient_order_id = args.delete :id
  			self_sym = self.new.attribute_names.map(&:to_sym)
  			args.keep_if {|k,v| self_sym.include?(k)}
  			args[:patient_order_id] = patient_order_id
  			self.create(args)
  			{flag:true,:info=>"订单的接收成功。"}
  		rescue Exception => e
  			print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 订单的接收 出错: " + e.backtrace.join("\n")
        {flag:false,:info=>"药房系统出错。"}
  		end
  	end

  end
end

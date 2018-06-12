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
  def return_order
  	self.update_attributes(status:"C")
  end


  class << self

  	# 订单查询()
  	def order_search args={}
      begin
        status = args[:status]
        search = args[:search]
        org_ii = args[:org_ii]
        query = {target_org_ii:org_ii,search_name:/#{search}/i}
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

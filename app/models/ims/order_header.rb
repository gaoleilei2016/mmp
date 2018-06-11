#encoding:utf-8
# => 药店-订单
# => 状态 status (A=>"待交费",P=>"待发药",E=>"已发药",C=>"已退药",S=>"已过期",O=>'取消/作废','T'=>"终止/暂停/中断")
class Ims::OrderHeader



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
  		self.where()
  	end

  	# 未指定药房的订单查询(未在平台上操作的患者也能在药店客户端协助患者自选药品购药)[可能查到]
  	def get_order args={}
  		
  	end

  	# 
  	# def method_name
  		
  	# end


  	# 订单的接收(接收完订单要发消息，提醒药房)
  	def receive_order args={}
  		
  	end

  end

end

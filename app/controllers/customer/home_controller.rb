class Customer::HomeController < ApplicationController
	layout "customer"
	def index
	end
	def confirm_order
		@order = ::Orders::Order.find(params[:id])
		# p '~~~~~~',@order
		if @order.status=='2'
			flash[:notice] = "支付成功"
			return redirect_to "/customer/home/order?id=#{@order.id}"
		elsif @order.status != "1"
			flash[:notice] = "不可支付"
			return redirect_to "/customer/home/order?id=#{@order.id}"
		end
	end
end

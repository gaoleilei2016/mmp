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
	def prescription
		respond_to do |f|
			f.html
			f.json{
				pre = ::Hospital::Prescription.find(params[:id]).to_web_front
				render json:{flag:true,prescription:pre}
			}
		end
	end
end

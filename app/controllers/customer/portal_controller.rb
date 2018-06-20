class Customer::PortalController < ApplicationController
	layout "customer"
	def index
	end
	def pay
		# p '~~~~~~~ pay',params
		@order = ::Orders::Order.find(params[:id])
		# p '~~~~~~',@order
		unless @order.status=='1'
			flash[:notice] = "不可支付的订单"
			return redirect_to "/customer/home/order?id=#{@order.id}"
		end
	end
	# 确认订单
	def settlement
		unless session[:cart_pharmacy_id].present?
			flash[:notice] = '请选择药房'
			redirect_to '/'
		end
		unless session[:cart_prescription_ids]&&session[:cart_prescription_ids].length>0
			flash[:notice] = '购物车空空如也'
			redirect_to '/'
		end
	end
end

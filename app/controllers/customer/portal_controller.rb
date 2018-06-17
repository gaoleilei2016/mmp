class Customer::PortalController < ApplicationController
	layout "customer"
	def index
	end
	def pay
		# p '~~~~~~~ pay',params
		@order = ::Orders::Order.find(params[:id])
		# p '~~~~~~',@order
	end
	# 确认订单
	def settlement
		unless session[:cart_pharmacy_id].present?
			flash['请选择药房']
			redirect_to '/'
		end
	end
end

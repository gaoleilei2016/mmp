class Customer::PortalController < ApplicationController
	layout "customer"
	def index
	end
	def pay
		# p '~~~~~~~ pay',params
		order = Orders::Order.find(params[:id])
		p '~~~~~~',order.net_amt
	end
end

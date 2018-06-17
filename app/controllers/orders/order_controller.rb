class ::Orders::OrderController < ApplicationController

	def index
		orders = ::Orders::Order.where("person_id = ? and status = ?" ,params[:person_id],params[:status])
		render json:{rows:orders,total:orders.count}
	end

end
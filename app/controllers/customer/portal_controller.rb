class Customer::PortalController < ApplicationController
	layout "customer"
	def index
	end
	def pay
		# p '~~~~~~~ pay',params
		@order = ::Orders::Order.find(params[:id])
		# p '~~~~~~~~~~~~',@order.net_amt.to_f.round(2)
		if session[:openid]
			args = {out_trade_no: "#{@order.id}_#{@order.settle_times}", total_fee: @order.net_amt.to_f.round(2), title: "华希订单-#{@order.order_code}", cost_name: '药品', return_url: "#{Set::Alibaba.domain_name}/customer/home/confirm_order?id=#{@order.id}&pay_type=#{params[:pay_type]}"}
			args[:openid] = session[:openid]
			# 微信内部支付
			@res = Pay::Wechat.public_pay(args)
			# p args,@res
			if @res[:state]==:succ
			else
				flash[:notice] = @res[:desc]
				return redirect_to "/"
			end
			# p '~~~~~~~~~~',res
			# return raise (res).to_json
		end
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

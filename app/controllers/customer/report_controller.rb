class Customer::ReportController < ApplicationController
	layout "customer"
	def index
		# p '~~~~~~~~',current_user.wowgo
		unless current_user.wowgo
			flash[:notice] = "体征信息未上传到社区，请重新填写您的体征信息"
			return redirect_to "/customer/home/user/edit?from=healthcloud"
		end
	end
	def qrcode
		if true
			# 未收费的用户 / 收费过期的用户
			return redirect_to '/customer/report/pay'
		end
	end
	def pay
		# # p '~~~~~~~ pay',params
		# @order = ::Orders::Order.find(params[:id])
		# # p '~~~~~~~~~~~~',@order
		# if session[:openid]
		# 	args = {out_trade_no: "#{@order.id}_#{@order.settle_times}_#{@order.created_at.to_i}", total_fee: @order.net_amt.to_f.round(2), title: "华希订单-#{@order.order_code}", cost_name: '药品', return_url: "#{Set::Alibaba.domain_name}/customer/home/confirm_order?id=#{@order.id}&pay_type=#{params[:pay_type]}"}
		# 	args[:openid] = session[:openid]
		# 	# 微信内部支付
		# 	@res = Pay::Wechat.public_pay(args)
		# 	# p args,@res
		# 	if @res[:state]==:succ
		# 	else
		# 		flash[:notice] = @res[:desc]
		# 		return redirect_to "/"
		# 	end
		# 	# p '~~~~~~~~~~',res
		# 	# return raise (res).to_json
		# end
		# unless @order.status=='1'
		# 	flash[:notice] = "不可支付的订单"
		# 	return redirect_to "/customer/home/order?id=#{@order.id}"
		# end
	end
	def hide_guide
		# p '~~~~~~~~~~~~',params[:type]
		if params[:type]=="once"
			session[:customer_report_is_read] = true
		elsif params[:type]=="forever"
			current_user.set_config(:customer_report_is_read,true)
		end
		render json:{flag:true,info:"操作成功"}
	end
end

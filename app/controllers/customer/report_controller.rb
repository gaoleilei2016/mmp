class Customer::ReportController < ApplicationController
	skip_before_action :verify_authenticity_token, :only => [:pay_order, :valid_pay_status]
	layout "customer"
	def index
		# p '~~~~~~~~',current_user.wowgo
		unless current_user.wowgo
			flash[:notice] = "体征信息未上传到社区，请重新填写您的体征信息"
			return redirect_to "/customer/home/user/edit?from=healthcloud"
		end
	end
	def qrcode
		if current_user.health_paid?
		else
			# 未收费的用户 / 收费过期的用户
			return redirect_to '/customer/report/pay'
		end
	end

	def orders
		respond_to do |f|
			f.html
			f.json{
				@orders = Pay::Order.where(openid: current_user.openid, pay_type: 'wechat', cost_name: '健康小站').page(params[:page]).per(params[:per])
				render json: {orders: @orders, total: @orders.total_count}
			}
		end
	end

	def valid_pay_status
		res = if params[:order_id]
						order = Pay::Order.find_by(out_trade_no: params[:order_id], pay_type: 'wechat')
						if order
							if order.status.eql?('success')
								flash[:notice] = '支付成功'
								{state: :succ, msg: '用户已支付', desc: '用户已支付'}
							else
								res = Pay::Wechat.order_query(order)
								if res[:state].eql?(:succ)
									flash[:notice] = '支付成功'
								end
								res
							end
						else
							{state: :error, msg: '无效订单号', desc: '订单号不存在'}
						end
					else
						{state: :error, msg: '无效订单号', desc: '订单不能为空'}
					end
		render json: res
	end

	def pay_order
		res = Pay::Wechat.get_pay_result(current_user.openid)
		render json: res
	end

	def advise
		res = if params[:type].eql?('weight')
						current_user.get_weight_bmi
					elsif params[:type].eql?('blood_pressure')
						current_user.get_blood_data
					else
						{error: true, msg: '未知的建议类型'}
					end
    respond_to do |f|
      f.html
      f.json {render json: res }
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

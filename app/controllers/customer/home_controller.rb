class Customer::HomeController < ApplicationController
	layout "customer"
	def index
	end
	def edit
	end
	def update
		# p '~~~~~~~ update',params
		current_user.update_attributes({
			name: params[:users][:name],
			sex: params[:users][:sex],
			birth: params[:users][:birth],
			height: params[:users][:height],
		})
		if current_user.valid?
			if params[:from]=='healthcloud'
				res = current_user.push_wowgo
				p '~~~~~~~~~~~~ from healthcloud',res
				flash[:notice] = res[:desc]
				if res[:state]==:succ
					redirect_to '/customer/report?first_use=true'
				else
					redirect_to '/customer/home/user/edit?from=healthcloud'
				end
			else
				Thread.new{
					res = current_user.push_wowgo
					p '~~~~~~~~~~~~ from edit',res
				}
				flash[:notice] = '保存成功'
				redirect_to '/customer/home'
			end
		else
			flash[:notice] = "失败：#{current_user.errors.messages}"
			render '/customer/home/edit'
		end
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
		pre = ::Hospital::Prescription.find(params[:id])
		pre.update_attributes(is_read: true)
		respond_to do |f|
			f.html
			f.json{
				render json:{flag:true,prescription:pre.to_web_front}
			}
		end
	end
	def save_password
		# p '~~~~~~~~~~',params
		# p current_user.valid_password?(params[:users][:old_password])
		if current_user.valid_password?(params[:users][:old_password])
			current_user.password = params[:users][:new_password]
			current_user.save
			flash[:notice] = "保存成功"
			redirect_to "/customer/home"
		else
			flash[:notice] = "密码错误"
			render "/customer/home/edit_password"
		end
	end
	def forget_password
		login = current_user.login
		sign_out(current_user)
		redirect_to "/users/sign_up?forget_password=true&login=#{login}"
	end
	# 卡券
	def get_coupons
		render json:{flag:true,rows:[],total:0}
	end
end

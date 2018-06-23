class Customer::FapiaoController < ApplicationController
	layout "customer"
	skip_before_action :verify_authenticity_token
	def index
		if params[:default]
			# 获取默认发票
			fapiao = ::Customer::Fapiao.where(user_id:current_user.id,default:'true').first
			render json:{flag:true,fapiao:fapiao}
		else
			fas = ::Customer::Fapiao.where(user_id:current_user.id).page(params[:page]).per(params[:per])
			render json:{flag:true,rows:fas,count:fas.count}
		end
	end
	def create
		_d = JSON.parse(params[:fapiao].to_json)
		_d['user_id'] = current_user.id
		if _d['default'].to_s == 'true'
			::Customer::Fapiao.where(user_id:current_user.id).update_all(default:nil)
		end
		if _d['id']
			fapiao = ::Customer::Fapiao.find(_d['id'])
			fapiao.update_attributes(_d)
		else
			fapiao = ::Customer::Fapiao.new(_d)
		end
		if fapiao.save
			render json:{flag:true,fapiao:fapiao,info:'更新成功'}
		else
			render json:{flag:false,info:"#{fapiao.errors.messages}"}
		end
	end
	def destroy
		::Customer::Fapiao.find(params[:id]).destroy
		render json:{flag:true,info:'操作成功'}
	end
end

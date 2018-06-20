class Admin::UsersController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
		# p '~~~~~~~~~ users index ',params
		users = ::User.where(:type_code=>params[:type_code].present? ? [params[:type_code]] : [nil,'','1','2']).where("id like '%#{params[:search]}%' OR name like '%#{params[:search]}%' OR jianpin like '%#{params[:search]}%' OR login like '%#{params[:search]}%'").order("created_at desc").page(params[:page]).per(params[:per])
		render json:{rows:users,total:users.total_count}
	end
	def show
		user = ::User.find(params[:id])
		render json:{flag:true,user:user}
	end
	def create
		user_data = JSON.parse(params[:user].to_json)
		# p '~~~~~~~~~ users create',user_data
		user = ::User.new(user_data)
		if user.save
			user.update_attributes(admin_level:'1',type_code:user.organization.type_code) if user.organization
			render json:{flag:true,info:"操作成功"}
		else
			render json:{flag:false,info:"#{user.errors.messages}"}
		end
	end
	def update
		user_data = JSON.parse(params[:user].to_json)
		# p '~~~~~~~~~ users update',user_data
		user = ::User.find(params[:id])
		if user.update_attributes(user_data)
			if user.organization
				user.update_attributes(admin_level:'1',type_code:user.organization.type_code)
			else
				user.update_attributes(admin_level:nil,type_code:nil)
			end
			render json:{flag:true,info:"操作成功"}
		else
			render json:{flag:false,info:"#{user.errors.messages}"}
		end
	end
	def destroy
		# p '~~~~~~~~~ users destroy',params
		params[:ids].each{|id|
			::User.find(id).destroy
		}
		render json:{flag:true,info:"操作成功"}
	end
end

class Admin::OrganizationsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
		# p '~~~~~~~~~ organizations index ',params
		orgs = ::Admin::Organization.where(:type_code=>params[:type_code].present? ? [params[:type_code]] : ['1','2']).where("id like '%#{params[:search]}%' OR name like '%#{params[:search]}%' OR jianpin like '%#{params[:search]}%'").order("created_at desc").page(params[:page]).per(params[:per])
		render json:{rows:orgs,total:orgs.total_count}
	end
	def show
		org = ::Admin::Organization.find(params[:id])
		render json:{flag:true,organization:org,users:org.users}
	end
	def create
		org_data = JSON.parse(params[:organization].to_json)
		# p '~~~~~~~~~ organizations create',org_data
		org = ::Admin::Organization.new(org_data)
		if org.save
			org.users = User.where(:id=>params[:user_ids])
			org.save
			render json:{flag:true,info:"操作成功"}
		else
			render json:{flag:false,info:"#{org.errors.messages}"}
		end
	end
	def update
		org_data = JSON.parse(params[:organization].to_json)
		# p '~~~~~~~~~ organizations update',org_data
		org = ::Admin::Organization.find(params[:id])
		if org.update_attributes(org_data)
			org.users = User.where(:id=>params[:user_ids])
			org.save
			render json:{flag:true,info:"操作成功"}
		else
			render json:{flag:false,info:"#{org.errors.messages}"}
		end
	end
	def destroy
		# p '~~~~~~~~~ organizations destroy',params
		params[:ids].each{|id|
			::Admin::Organization.find(id).destroy
		}
		render json:{flag:true,info:"操作成功"}
	end
end

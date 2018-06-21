class Admin::OrganizationsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
		# p '~~~~~~~~~ organizations index ',params
		orgs = ::Admin::Organization.where(:type_code=>params[:type_code].present? ? [params[:type_code]] : ['1','2']).where("id like '%#{params[:search]}%' OR name like '%#{params[:search]}%' OR jianpin like '%#{params[:search]}%'").order("created_at desc").page(params[:page]).per(params[:per])
		render json:{rows:orgs,total:orgs.total_count}
	end
	def show
		org = ::Admin::Organization.find(params[:id])
		if org.type_code=='1'
			organizations = org.pharmacy_link.map{|l|l.pharmacy}.compact
		else
			organizations = org.hospital_link.map{|l|l.hospital}.compact
		end
		render json:{flag:true,organization:org,users:org.users,organizations:organizations}
	end
	def create
		org_data = JSON.parse(params[:organization].to_json)
		# p '~~~~~~~~~ organizations create',org_data
		org = ::Admin::Organization.new(org_data)
		if org.save
			org.users = User.where(:id=>params[:user_ids])
			org.save
			org.users.update_all(:admin_level=>"1",type_code:org.type_code)
			(params[:organization_ids]||[]).each{|o_id|
				if org.type_code=='1'
					org.pharmacy_link.create(pharmacy_id:o_id)
				else
					org.hospital_link.create(hospital_id:o_id)
				end
			}
			# org.organizations = ::Admin::Organization.where(:id=>params[:organization_ids])
			# org.save
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
			org.users.update_all(:admin_level=>nil,type_code:nil)
			org.users = User.where(:id=>params[:user_ids])
			org.save
			org.users.update_all(:admin_level=>"1",type_code:org.type_code)
			if org.type_code=='1'
				org.pharmacy_link.each{|x| x.destroy}
				(params[:organization_ids]||[]).each{|o_id|
					org.pharmacy_link.create(pharmacy_id:o_id)
				}
			else
				org.hospital_link.each{|x| x.destroy}
				(params[:organization_ids]||[]).each{|o_id|
					org.hospital_link.create(hospital_id:o_id)
				}
			end
			# org.organizations = ::Admin::Organization.where(:id=>params[:organization_ids])
			# org.save
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

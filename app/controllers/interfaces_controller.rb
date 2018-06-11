class InterfacesController < ApplicationController
	#############################
	############ zyz ############
	def get_pharmacy
		orgs = ::Admin::Organization.where(:type_code=>'2')
		render json:{rows:orgs,total:orgs.count}
	end
	############ zyz ############
	#############################

	#############################
	############ xixu ############
	def get_dicts
		p '~~~~~~~~~~~~~~~',params[:oid]
		ret = ::User.find_by_sql("select  dictdata.code ,dictdata.name  from dictdata where dictdata .oid='#{params[:oid]}'")
		render json:{rows:ret,total:ret.count}
	end
	############ xixu ############
	#############################



	def get_addrs
		p '~~~~~~~~~~~~~~~',params[:code]
		ret = ::User.find_by_sql("select dictdata.name  from dictdata where dictdata .oid='#{params[:code]}'")
		render json:{rows:ret,total:ret.count}
	end

  

def get_medicine_by_name
		p '~~~~~~~~~~~~~~~',params[:name]
		ret = ::User.find_by_sql("select *  from dictmedicine where dictmedicine.name  like '%#{params[:name]}%'")
		render json:{rows:ret,total:ret.count}
	end


end

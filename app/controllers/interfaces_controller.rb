class InterfacesController < ApplicationController
	#############################
	############ zyz ############
	def get_pharmacy
		org = current_user.organization
		raise "无机构的用户" unless org
		raise "非医院的用户" unless org.type_code=='1'
		if org.yaofang_type
			orgs = org.pharmacy_link.map{|x| x.pharmacy}.compact
		else
			orgs = ::Admin::Organization.where(:type_code=>'2')
		end
		render json:{rows:orgs,total:orgs.count}
	end
	############ zyz ############
	#############################

	#############################
	############ xixu ############
	def get_dicts    #根据字典编号获取字典数据
		params[:oid]
		ret = ::User.find_by_sql("select  dictdata.code ,dictdata.name  from dictdata where dictdata .oid='#{params[:oid]}'")
		render json:{rows:ret,total:ret.count}
	end
	



	def get_addrs   ##根据编码获取行政区划地址
		params[:code]
		ret = ::User.find_by_sql("select  a.*  from dictarea a  where  ('#{params[:code]}'='' and a.supcode is null) or ('#{params[:code]}'<>'' and a.supcode='#{params[:code]}')  and a.status<>'T'")
		render json:{rows:ret,total:ret.count}
	end

  

def get_medicine_by_name
		params[:name]
		ret = ::User.find_by_sql("select *  from dictmedicine where dictmedicine.name  like '%#{params[:name]}%'")
		render json:{rows:ret,total:ret.count}
	end

    ############ xixu ############
	#############################

end

class ::Dict::DiseasesController < ApplicationController
	rescue_from RuntimeError do |exception|
		respond_to do |html|
			html.html {render xml:{flag:false,reason:exception.class.to_s,info:exception.message}}
			html.json {render json:{flag:false,reason:exception.class.to_s,info:exception.message}}
		end
	end


	# 查询病种字典返回ICD10诊断列表	
	# GET
	# /dict/diseases
	def index
		p "::Dict::DiseasesController index", params
		search = params[:search].to_s
		page = params[:page] || 1
		per = params[:per] || 25
		@diseases = ::Dict::Disease.where("ICD10 LIKE ?  OR name LIKE ? OR py LIKE ?", "%#{search}%", "%#{search}%", "%#{search.upcase}%").page(page).per(per)
		ret = @diseases.map { |e| e.to_ICD10_fhir_type }
	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: {flag: true, info:"success", data: ret} }
	    end
	end

	# 查询某一个病种信息  按ICD10模式显示 只返回json格式
	# GET
	def show
		return render json:{flag: false, info:"病种id不能为空"} if params[:id].nil?
		@disease = ::Dict::Disease.find(params[:id])
		render json:{flag: true, info: "success", data: @disease.to_ICD10_fhir_type}
	end

	def destroy
		@disease = ::Dict::Disease.find(params[:id])
	end
end
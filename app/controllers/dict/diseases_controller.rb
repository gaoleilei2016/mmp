class ::Dict::DiseasesController < ApplicationController
	# before_action :set_disease, only: [:show, :edit, :update, :destroy]
	# GET
	# /dict/diseases
	def index
		p "::Dict::DiseasesController index"
		search = params[:search].to_s
		@diseases = ::Dict::Disease.where("ICD10 LIKE ?  OR name LIKE ? OR py LIKE ?", "%#{search}%", "%#{search}%", "%#{search.upcase}%").page(params[:page]||1).per(params[:per]||25)
		ret = @diseases.map { |e| e.to_ICD10_fhir_type }
	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render json: {flag: true, info:"", data: ret} }
	    end
	end

	# # GET
 #  # /dict/diseases/:id
	# def show
	#   respond_to do |format|
 #      format.html # show.html.erb
 #      format.json { render json: {flag: true, info:"", data: @disease} }
 #    end
	# end

	# # GET
	# # GET /dict/diseases/new.json
	# def new
	#   @disease = ::Dict::Disease.new
	#   respond_to do |format|
	#     format.html # new.html.erb
	#     format.json { render json: {flag: true, info:"", data: @disease} }
	#   end
	# end

	# # GET
	# # /dict/diseases/:id/edit
	# def edit
	# end

	# 	# POST
	# # /dict/diseases
	# def create
	#   p "==========create", params
	#   @disease = ::Dict::Disease.new(params[:disease])
	#   respond_to do |format|
	#     if @disease.save
	#       format.html { redirect_to @disease, notice: 'disease was successfully created.' }
	#       format.json { render json: {flag: true, info:"", data: @disease} }
	#     else
	#       format.html { render action: "new" }
	#       format.json { render json: @disease.errors, status: :unprocessable_entity }
	#     end
	#   end
	# end

	# 	# PUT
	# # PUT /dict/diseases/:id
	# def update
	#   p "==========update", params
	#   respond_to do |format|
	#     if @disease.update_attributes(params[:disease])
	#       format.html { redirect_to @disease, notice: 'disease was successfully updated.' }
	#       format.json { render json: {flag: true, info:"", data: @disease} }
	#     else
	#       format.html { render action: "edit" }
	#       format.json { render json: @disease.errors, status: :unprocessable_entity }
	#     end
	#   end
	# end

	# # DELETE
 #  # /dict/diseases/:id
	# def destroy
	# 	@disease.destroy
	#   respond_to do |format|
	#     format.html { redirect_to diseases_url }
	#     format.json { head :no_content }
	#   end
	# end

	# private
 #    # Use callbacks to share common setup or constraints between actions.
 #    def set_disease
 #      @disease = ::Dict::Disease.find(params[:id])
 #    end
end
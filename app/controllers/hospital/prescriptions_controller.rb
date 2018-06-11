#encoding:utf-8
#处方
class Hospital::PrescriptionsController < ApplicationController
	before_action :set_prescription, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/prescriptions
	def index
		@prescriptions = Hospital::Prescription.all rescue []

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: @prescriptions} }
    end
	end

	# GET
  # /hospital/prescriptions/:id
	def show
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @prescription} }
    end
	end

	# GET
  # GET /hospital/prescriptions/new.json
  def new
    @prescription = Hospital::Prescription.new
    res = {
      title: "",  # 药品名
    }
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {flag: true, info:"", data: @prescription} }
    end
  end

	# GET
  # /hospital/prescriptions/:id/edit
	def edit
	end

	# POST
  # /hospital/prescriptions
	def create
		@prescription = Hospital::Prescription.new(params[:prescription])

    respond_to do |format|
      if @prescription.save
        format.html { redirect_to @prescription, notice: 'prescription was successfully created.' }
        format.json { render json: {flag: true, info:"", data: @prescription} }
      else
        format.html { render action: "new" }
        format.json { render json: @prescription.errors, status: :unprocessable_entity }
      end
    end
	end

	# PUT
  # PUT /hospital/prescriptions/:id
  def update

    respond_to do |format|
      if @prescription.update_attributes(params[:prescription])
        format.html { redirect_to @prescription, notice: 'prescription was successfully updated.' }
        format.json { render json: {flag: true, info:"", data: @prescription} }
      else
        format.html { render action: "edit" }
        format.json { render json: @prescription.errors, status: :unprocessable_entity }
      end
    end
  end

	# DELETE
  # /hospital/prescriptions/:id
	def destroy
		@prescription.destroy

    respond_to do |format|
      format.html { redirect_to prescriptions_url }
      format.json { head :no_content }
    end
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_prescription
      @prescription = Hospital::Prescription.find(params[:id])
    end
end

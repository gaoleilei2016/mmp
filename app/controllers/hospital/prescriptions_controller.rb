#encoding:utf-8
#处方
class Hospital::PrescriptionsController < ApplicationController
	before_action :set_prescription, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/prescriptions
	def index
		@prescriptions = Hospital::Prescription.all rescue []
    @prescriptions = @prescriptions.map { |e| e.to_web_front  }
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
      title: "",
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
    p "Hospital::PrescriptionsController create", params
    args = format_prescription_create_args
		@prescription = ::Hospital::Prescription.new(args[:prescription])
    respond_to do |format|
      if @prescription.save
        p "prescription save"
        @prescription.link_diagnoses(args[:diagnoses_args], current_user)
        p "link_diagnoses save"
        @prescription.link_orders(args[:cur_orders], current_user)
        p "link_orders save"
        # 发送处方消息
        @prescription.send_to_check()
        format.html { redirect_to @prescription, notice: 'prescription was successfully created.' }
        format.json { render json: {flag: true, info:"", data: @prescription.to_web_front} }
      else
        @prescription.
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

  # GET
  # /hospital/prescriptions/get_prescriptions_by_phone
  def get_prescriptions_by_phone
    p "get_prescriptions_by_phone", params
    cur_phone = params[:phone]
    return render json: {flag: false, info: "电话号不能为空"} if cur_phone.nil?
    p cur_phone
    @prescriptions = ::Hospital::Interface.get_prescription(cur_phone).map { |e| e.to_web_front  }
    render json: {flag: true, info: "success", data: @prescriptions}
  end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_prescription
      @prescription = Hospital::Prescription.find(params[:id])
    end

    def prescription_params
      params[:prescription]
    end

    def format_prescription_create_args
      args = prescription_params
      cur_orders = ::Hospital::Order.find(args[:ids])
      cur_encounter = ::Hospital::Encounter.find(params[:encounter_id])
      cur_org = current_user.organization
      diagnoses_args = args[:diagnoses]
      prescription = {
        organization_id: cur_org.id,
        status: "N",
        note: args[:note],
        type_code: "1",
        type_display: "普通处方",
        bill_id: nil,
        confidentiality_code: "0",
        confidentiality_display: "医院",
        doctor_id: current_user.id,
        encounter_id: cur_encounter.id,
        effective_start: Time.now,
        effective_end: Time.now + 1.day,
      }
      ret = {
        prescription: prescription,
        diagnoses_args: diagnoses_args,
        cur_orders: cur_orders
      }
      p ret
      return ret
    end
end

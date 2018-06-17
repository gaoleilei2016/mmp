#encoding:utf-8
#处方
class Hospital::PrescriptionsController < ApplicationController
	before_action :set_prescription, only: [:show, :edit, :update, :destroy, :set_prescription]
	# GET
  # /hospital/prescriptions
	def index
    # 只能通过 encounter_id 查询医嘱
    p "Hospital::PrescriptionsController index",params
		@prescriptions = Hospital::Prescription.where(encounter_id: params[:encounter_id]).map { |e| e.to_web_front  }
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
    return render json:{flag: false, info: "医嘱状态不能生成处方"} if !::Hospital::Order.can_to_prescription?(params[:prescription][:ids])
		@prescription = ::Hospital::Prescription.new(args[:prescription])
    respond_to do |format|
      if @prescription.save
        p "prescription save"
        @prescription.link_diagnoses(args[:diagnoses_args], current_user)
        p "link_diagnoses save"
        @prescription.link_orders(args[:cur_orders], current_user)
        p "link_orders save"
        # 审核人信息  每个医院维护的都不一样  通过设置  设置审核人
        audit_args = {
          auditor: {
            id: current_user.id,
            display: current_user.name
          },
          audit_at: Time.now
        }
        @prescription.audit(audit_args, current_user)
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
		@prescription.update_attributes(:status=>7)

    respond_to do |format|
      format.html { redirect_to prescriptions_url }
      format.json { render json: {flag: true, info:"处方作废成功", data: @prescription} }
    end
	end

  # GET
  # /hospital/prescriptions/get_prescriptions_by_phone
  # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 我的首页，获取未取药的有效的处方，并按医院合并，方便下订单 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 获取未取药的有效的处方，并按医院合并，方便下订单 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 获取未取药的有效的处方，并按医院合并，方便下订单 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  # 获取未取药的有效的处方，并按医院合并后下订单
  def get_prescriptions_by_phone
    # p "get_prescriptions_by_phone", params
    cur_phone = params[:phone]
    return render json: {flag: false, info: "电话号不能为空"} if cur_phone.nil?
    ret = []
    ::Hospital::Interface.get_prescriptions_by_phone(cur_phone,'1').group_by {|_prescription| {org_id: _prescription.organization.id, org_name: _prescription.organization.name}}.each do |cur_org, _prescriptions|
      prescription_ids = []
      total_price = 0.0
      orders = _prescriptions.map { |e| prescription_ids<<e.id;e.orders}.flatten.map { |k| total_price+=k.price*k.total_quantity;k.to_web_front;  }
      cur_org[:prescription_ids] = prescription_ids
      cur_org[:total_price] = total_price
      cur_org[:orders] = orders
      ret << cur_org
    end
    render json: {flag: true, info: "success", data: ret}
  end
  # GET
  # /hospital/prescriptions/get_prescriptions_by_phone
  # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 我的处方页面，获取所有处方以及是否过期等状态 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 获取所有处方以及是否过期等状态 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 获取所有处方以及是否过期等状态 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  # 获取所有处方以及过期等状态
  def get_all_prescriptions_by_phone
    cur_phone = params[:phone]
    return render json: {flag: false, info: "电话号不能为空"} if cur_phone.nil?
    ret = []
    ::Hospital::Interface.get_prescriptions_by_phone(cur_phone).each do |_prescription|
      re = JSON.parse(_prescription.to_json)
      # total_price = 0.0
      # orders = _prescription.orders.map { |k| total_price+=k.price*k.total_quantity;k.to_web_front;  }
      # re[:total_price] = total_price
      # re[:orders] = orders
      # re[:organ] = Admin::Organization.find(_prescription.organization_id)
      # ret << re
      ret << _prescription.to_web_front
    end
    render json: {flag: true, info: "success", data: ret}
  end

  # /# POST
  # /hospital/prescriptions/:id/set_drug_store
  def set_drug_store
    p "set_drug_store", params
    respond_to do |format|
      if @prescription.update_attributes(drug_store_id: params[:pharmacy_id])
        format.json { render json: {flag: true, info:"设置处方发药房成功", data: @prescription} }
      else
        format.json { render json: { flag: false, info: @prescription.errors }}
      end
    end
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
        status: 0,
        note: args[:note],
        type_code: args[:type][:code],
        type_display: args[:type][:display],
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

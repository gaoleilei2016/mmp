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
      format.json { render json: {flag: true, info:"", data: @prescription.to_web_front} }
    end
	end

	# GET
  # GET /hospital/prescriptions/new.json
  def new
    # @prescription = Hospital::Prescription.new
    # respond_to do |format|
    #   format.html # new.html.erb
    #   format.json { render json: {flag: true, info:"", data: @prescription} }
    # end
    render json:{flag: false, info: "暂未支持该方法"}
  end

	# GET
  # /hospital/prescriptions/:id/edit
	def edit
    render json:{flag: false, info: "暂未支持该方法"}
	end

	# POST
  # /hospital/prescriptions
	def create
    p "Hospital::PrescriptionsController create", params
    args = format_prescription_create_args
    # 审核人信息  每个医院维护的都不一样  通过设置  设置审核人
    audit_args = {
      auditor: {
        id: current_user.id,
        display: current_user.name
      },
      audit_at: Time.now
    }
    prescription_ids = []
    return render json:{flag: false, info: "医嘱状态不能生成处方 请刷新重试"} if !::Hospital::Order.can_to_prescription?(params[:prescription][:ids])
    group_orders = args[:cur_orders].group_by.with_index {|e, i| i/5} # 每个处方不超过五个药
    ::ActiveRecord::Base.transaction  do
      group_orders.values.each do |_orders|
		    @prescription = ::Hospital::Prescription.new(args[:prescription])
        @prescription.save!
        @prescription.link_diagnoses!(args[:diagnoses_args], current_user) # 连接诊断
        @prescription.link_orders!(_orders, current_user)  # 连接医嘱
        @prescription.set_tookcode! #设置取药码
        @prescription.audit!(audit_args, current_user) # 审核
        prescription_ids << @prescription.id
      end
    end
    ret = ::Hospital::Prescription.find(prescription_ids)
    ret.each {|e| e.send_to_check()} # 发送处方生成成功信息
    # ret = ret.map { |e| e.to_web_front  } # 返回数据格式化
    render json: {flag: true, info:""}
    # render json: {flag: false, info: @prescription.errors.messages.join("、")}
	end

	# PUT
  # PUT /hospital/prescriptions/:id
  def update
    # respond_to do |format|
    #   if @prescription.update_attributes(params[:prescription])
    #     format.html { redirect_to @prescription, notice: 'prescription was successfully updated.' }
    #     format.json { render json: {flag: true, info:"", data: @prescription} }
    #   else
    #     format.html { render action: "edit" }
    #     format.json { render json: {flag: false, info: @prescription.errors.messages.join("、")} }
    #   end
    # end
    render json:{flag: false, info: "暂未支持该方法"}
  end

	# DELETE
  # /hospital/prescriptions/:id
	def destroy
    respond_to do |format|
      args = {
        abandonor: {
          id: current_user.id,
          display: current_user.name
        },
        abandon_at: Time.now
      }
      case @prescription.status
      when 1
        @prescription.abandon(args, current_user)
        format.json { render json: {flag: true, info:"处方作废成功", data: @prescription} }
      when 2
        @prescription.not_audit_to_abandon(args, current_user)
        format.json { render json: {flag: true, info:"处方作废成功", data: @prescription} }
      else
        format.json { render json: {flag: false, info:"该状态不予许作废处方 如需作废 请联系管理员处理"} }
      end
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
      cur_org[:prescriptions] = _prescriptions.map{|x| 
        prescription_ids<<x.id
        x.to_web_front
      }
      # ret << cur_org
      # total_price = 0.0
      # _status = []
      # orders = _prescriptions.map { |e| prescription_ids<<e.id;_status<<e.status;e.orders}.flatten.map { |k| total_price+=k.price*k.total_quantity;k.to_web_front;  }
      cur_org[:prescription_ids] = prescription_ids
      cur_org[:prescription_ids2] = prescription_ids
      # cur_org[:total_price] = total_price
      # cur_org[:orders] = orders
      # cur_org[:status] = _status
      cur_org[:first_created_at] = _prescriptions[0].created_at
      ret << cur_org
    end
    render json: {flag: true, info: "success", data: ret}
  end
  # GET
  # /hospital/prescriptions/get_all_prescriptions_by_phone
  # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 我的处方页面，获取所有处方以及是否过期等状态 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 获取所有处方以及是否过期等状态 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  # $$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 获取所有处方以及是否过期等状态 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  # 获取所有处方以及过期等状态
  def get_all_prescriptions_by_phone
    cur_phone = params[:phone].to_s
    return render json: {flag: false, info: "电话号不能为空"} if cur_phone.blank?
    ret = []
    page = params[:page]||1
    per = params[:per]||5
    sort = "DESC"
    ::Hospital::Interface.get_prescriptions_by_phone_with_sort(cur_phone, page, per, sort).each do |_prescription|
      ret << _prescription.to_web_front
    end
    count = ::Hospital::Interface.get_prescriptions_count_by_phone(cur_phone)
    render json: {flag: true, info: "success", data: ret, count: count}
  end

  # PUT
  # 根据处方ids更新 处方已读
  # {
  #   prescription_ids: []
  # }
  def read_prescription
    return render json:{flag: false, info:"无效处方ids"} if params[:prescription_ids].nil?
    ::Hospital::Prescription.where("id" => params[:prescription_ids]).update_all(is_read: true)
    render json:{flag: true, info:"success"}
  end

  # GET
  # 获取未读处方的数量  通过电话查询
  # {phone: ""}
  def get_not_read_prescription
    return render json:{flag: false, info:"没有电话号码或格式不正确"} if params[:phone].nil?
    cur_phone = params[:phone]
    count = ::Hospital::Interface.get_not_read_prescriptions_by_phone(cur_phone).count
    render json:{flag: true, info: "success", count: count}
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
        author_id: current_user.id,
        encounter_id: cur_encounter.id,
        effective_start: Time.now,
        effective_end: Time.now + 1.day,
      }
      ret = {
        prescription: prescription,
        diagnoses_args: diagnoses_args,
        cur_orders: cur_orders
      }
      return ret
    end
end

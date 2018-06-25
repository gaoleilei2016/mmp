#encoding:utf-8
#处方
class Hospital::PrescriptionsController < ApplicationController
  before_action :set_cur_org
  before_action :set_cur_encounter
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
    # render json: {flag: false, info: @prescription.errors.messages.flatten.join("、")}
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
    #     format.json { render json: {flag: false, info: @prescription.errors.messages.flatten.join("、")} }
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

  # /# POST
  # /hospital/prescriptions/:id/set_drug_store
  def set_drug_store
    p "set_drug_store", params
    respond_to do |format|
      if @prescription.update_attributes(drug_store_id: params[:pharmacy_id])
        format.json { render json: {flag: true, info:"设置处方发药房成功", data: @prescription} }
      else
        format.json { render json: { flag: false, info: "#{@prescription.errors.messages}" }}
      end
    end
  end

	private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end
    # 获取当前就诊信息
    def set_cur_encounter
      @cur_encounter =  ::Hospital::Encounter.find(params[:encounter_id]) rescue nil
      return render json:{flag:false, info: "无效就诊id 请刷新重试 或联系管理员"} if @cur_encounter.nil?
      return render json:{flag:false, info: "非本人创建数据 不可操作"} if @cur_encounter.author_id != current_user.id
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_prescription
      @prescription = Hospital::Prescription.find(params[:id])
    end

    def prescription_params
      params[:prescription]
    end

    def format_prescription_create_args
      args = prescription_params
      begin
        cur_orders = ::Hospital::Order.find(args[:ids])
        diagnoses_args = args[:diagnoses]
        prescription = {
          organization_id: @cur_org.id,
          status: 0,
          note: args[:note],
          type_code: (args[:type]||{})[:code],
          type_display: (args[:type]||{})[:display],
          bill_id: nil,
          confidentiality_code: "0",
          confidentiality_display: "医院",
          doctor_id: current_user.id,
          author_id: current_user.id,
          encounter_id: @cur_encounter.id,
          effective_start: Time.now,
          effective_end: Time.now + 1.day,
        }
        ret = {
          prescription: prescription,
          diagnoses_args: diagnoses_args,
          cur_orders: cur_orders
        }
      rescue Exception => e
        raise "未知数据格式 #{e.message}"
      end
      return ret
    end
end

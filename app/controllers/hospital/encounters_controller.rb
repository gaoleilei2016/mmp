#encoding:utf-8
#接诊管理、统计
class Hospital::EncountersController < ApplicationController
	before_action :set_encounter, only: [:show, :edit, :update, :destroy, :all_prescriptions]
	# GET
  # /hospital/encounters
	def index
    p "Hospital::EncountersController index", params
    search = params[:search].to_s
		@encounters = Hospital::Encounter.where("iden LIKE ? OR phone LIKE ? OR name LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%").order(created_at: :desc).page(params[:page]||1).per(params[:per]||25).map { |e| e.to_web_front  }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: @encounters} }
    end
	end
  
	# GET
  # /hospital/encounters/:id
	def show
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @encounter.to_web_front} }
    end
	end

	# GET
  # GET /hospital/encounters/new.json
  def new
    @encounter = Hospital::Encounter.new
    res = {
      name: "",  # 姓名
      gender: {code: "", display: ""},  # 性别
      age: "",  # 年龄
      birth_date: "",  # 出生日期
      iden: "",  # 身份证号码
      phone: "",  # 电话
      address: "",  # 住址
      occupation: {code: "", display: ""},  # 职业
      contact_name: "",  # 联系人
      nation: {code: "", display: ""},  # 民族
      marriage: {code: "", display: ""},  # 婚姻
      unit_name: "",  # 工作单位（学校）
      diagnoses: [],  # 诊断
      allergens: [],  # 过敏
      blood: {code: "", display: ""},  # 血型
      height: "",  # 身高cm
      weight: "",  # 体重kg
      location: {id: "", display: ""}, # 取药点
    }
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {flag: true, info:"", data: @encounter} }
    end
  end

	# GET
  # /hospital/encounters/:id/edit
	def edit
	end

  # POST
  # 引用医嘱
  # /hospital/encounters/quote_orders
  def quote_orders
    p " quote_orders",params
    flag = ::Hospital::Order.copy_orders(params[:ids], params[:encounter_id], current_user)
    info = flag ? "引用成功" : "复制出错 有药品以停用" 
    # cur_encounter_orders = @encounter.orders.map { |_order| _order.to_web_front  }
    render json: {flag: flag, info: info}
  end





	# POST
  # /hospital/encounters
  # 就诊信息创建总共有四种方式
  # 1：通过查询的就诊列表创建新的就诊  参数  type: "by_person", person_id: 
  # 2：通过刷身份证创建就诊 (刷身份证自动像后台发起请求创建信息) type: "by_iden", iden: ""
  # 3：通过扫二维码创建就诊 type: "by_qrcode", qrcode: 
  # 4：手动输入信息后保存创建就诊 （采用姓名、手机号做唯一识别  查询Person信息做关联） type: "by_write"
	def create
    p "Hospital::EncountersController ==========create", params
    # raise "测试"
    case params[:type].to_s
    when "by_person"
      cur_person = ::Person.find(params[:encounter][:person_id]) rescue nil
      render json: {flag: false, info:"person_id 无效"} if cur_person.nil?
      cur_org = current_user.organization
      encounter_info = ::Hospital::Encounter.get_encounter_info_from_person(cur_person.id)
      encounter_info.merge!(person_id: cur_person.id, author_id: current_user.id, hospital_oid: cur_org.id, hospital_name: cur_org.name)
      @encounter = ::Hospital::Encounter.new(encounter_info)
      if @encounter.save
        render json: {flag: true, info:"success", data: @encounter.to_web_front}
      else
        render json: {flag: true, info: @encounter.errors.messages.values.flatten, data:nil}
      end
    when "by_iden"
      render json: {flag: false, info:"该功能在计划开发中  暂不支持"}
    when "by_qrcode"
      render json: {flag: false, info:"该功能在计划开发中  暂不支持"}
    when "" # by_write默认不传 手动填写
      create_data = format_encounter_create_params
      @encounter = ::Hospital::Encounter.new(create_data[:encounter])
      respond_to do |format|
        ::ActiveRecord::Base.transaction  do
          if @encounter.save! # 保存成功后创建诊断和过敏信息
            cur_person = @encounter.get_person
            # p "person_id = #{cur_person.id} name = #{cur_person.name}"
            @encounter.update_attributes!(::Hospital::Encounter.get_encounter_info_from_person(cur_person.id))
            ::Hospital::Irritability.batch_update(create_data[:irritabilities], cur_person, current_user)
            ::Hospital::Diagnose.batch_update(create_data[:diagnoses], @encounter, current_user)
            format.html { redirect_to @encounter.to_web_front, notice: 'encounter was successfully created.' }
            format.json { render json: {flag: true, info:"", data: @encounter.to_web_front} }
          else
            format.html { render action: "new" }
            format.json { render json: @encounter.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      render json: {flag: false, info: "该功能不提供  请正确流程使用系统"}
    end
	end

	# PUT
  # PUT /hospital/encounters/:id
  def update
    p "==========update", params
    update_data = format_encounter_update_params
    respond_to do |format|
      ::ActiveRecord::Base.transaction  do
        if @encounter.update_attributes!(update_data[:encounter])
          cur_person = @encounter.person
          cur_person.update_attributes!(@encounter.format_person_args)
          ::Hospital::Irritability.batch_update(update_data[:irritabilities], cur_person, current_user)
          ::Hospital::Diagnose.batch_update(update_data[:diagnoses], @encounter, current_user)
          format.html { redirect_to @encounter, notice: 'encounter was successfully updated.' }
          format.json { render json: {flag: true, info:"", data: @encounter.to_web_front} }
        else
          format.html { render action: "edit" }
          format.json { render json: @encounter.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET
  # /hospital/encounters/:id/all_prescriptions
  def all_prescriptions
    @prescriptions = @encounter.prescriptions.map { |e| e.to_web_front }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: @prescriptions} }
    end
  end

	# DELETE
  # /hospital/encounters/:id
	def destroy
		@encounter.destroy

    respond_to do |format|
      format.html { redirect_to encounters_url }
      format.json { head :no_content }
    end
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_encounter
      @encounter = Hospital::Encounter.find(params[:id])
    end

    def encounter_params
      # params.require(:encounter).permit(:name, :gender, :age, :birth_date, :iden, :phone, :address, :occupation, :contact_name, :nation, :marriage, :unit_name, :diagnoses, :allergens, :blood, :height, :weight, :drugstore_location)     
      params[:encounter]
    end

    def format_encounter_create_params
      args = encounter_params
      cur_hospital = current_user.organization
      encounter_agrs = {
        name: args[:name],
        gender_code: args[:gender][:code], 
        gender_display: args[:gender][:display], 
        age: args[:age], 
        birth_date: args[:birth_date], 
        iden: args[:iden], 
        phone: args[:phone], 
        address: args[:address], 
        occupation_code: args[:occupation][:code], 
        occupation_display: args[:occupation][:display], 
        contact_name: args[:contact_name],
        hospital_oid: cur_hospital.id,
        hospital_name: cur_hospital.name,
        nation_code: args[:nation][:code], 
        nation_display: args[:nation][:display], 
        marriage_code: args[:marriage][:code], 
        marriage_display: args[:marriage][:display],
        unit_name: args[:unit_name], 
        blood_code: args[:blood][:code], 
        blood_display: args[:blood][:display], 
        height: args[:height], 
        weight: args[:weight], 
        drugstore_location_id: args[:drugstore_location][:id],
        author_id: current_user.id
      }
      diagnose_args = args[:diagnoses]  #诊断信息
      allergen_args = args[:allergens] #过敏信息
      ret  = {
        encounter: encounter_agrs,
        diagnoses: diagnose_args, # ICD10 [{code: '', display: ''}]
        irritabilities: allergen_args # ['过敏一', '过敏二']
      }
    end

    def format_encounter_update_params
      args = encounter_params
      encounter_agrs = {
        name: args[:name],
        gender_code: args[:gender][:code], 
        gender_display: args[:gender][:display], 
        age: args[:age], 
        birth_date: args[:birth_date], 
        iden: args[:iden], 
        phone: args[:phone], 
        address: args[:address], 
        occupation_code: args[:occupation][:code], 
        occupation_display: args[:occupation][:display], 
        contact_name: args[:contact_name], 
        nation_code: args[:nation][:code], 
        nation_display: args[:nation][:display], 
        marriage_code: args[:marriage][:code], 
        marriage_display: args[:marriage][:display],
        unit_name: args[:unit_name], 
        blood_code: args[:blood][:code], 
        blood_display: args[:blood][:display], 
        height: args[:height], 
        weight: args[:weight], 
        drugstore_location_id: args[:drugstore_location][:id],
        author_id: current_user.id
      }
      diagnose_args = args[:diagnoses]  #诊断信息
      allergen_args = args[:allergens] #过敏信息
      ret  = {
        encounter: encounter_agrs,
        diagnoses: diagnose_args, # ICD10 [{code: '', display: ''}]
        irritabilities: allergen_args # ['过敏一', '过敏二']
      }
      p ret
      return ret
    end
end

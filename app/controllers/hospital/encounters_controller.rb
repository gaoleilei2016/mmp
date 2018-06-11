#encoding:utf-8
#接诊管理、统计
class Hospital::EncountersController < ApplicationController
	before_action :set_encounter, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/encounters
	def index
		@encounters = Hospital::Encounter.all.map { |e| e.to_web_front  }

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
      diagnoses: [{ code: "", display: ""}],  # 诊断
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
  # /hospital/encounters
	def create
    p "==========create", params
    create_data = format_encounter_create_params
		@encounter = Hospital::Encounter.new(create_data[:encounter])
    p @encounter
    respond_to do |format|
      if @encounter.save # 保存成功后创建诊断和过敏信息
        cur_person = @encounter.get_person
        p cur_person
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

	# PUT
  # PUT /hospital/encounters/:id
  def update
    p "==========update", params
    update_data = format_encounter_update_params
    respond_to do |format|
      if @encounter.update_attributes(update_data[:encounter])
        cur_person = @encounter.person
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
        drugstore_location_id: args[:drugstore_location][:id]
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
        drugstore_location_id: args[:drugstore_location][:id]
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

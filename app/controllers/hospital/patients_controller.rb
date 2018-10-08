#encoding:utf-8
#接诊管理、统计
class Hospital::PatientsController < ApplicationController
	before_action :set_cur_org


  # 根据医生 医生所在机构 查询接诊过的就诊列表
	# GET
  # /hospital/patients
  # {search: String}
	def index
    p "Hospital::PatientsController index", params
    search = params[:search].to_s
    @people = ::Person.where("iden LIKE ? OR phone LIKE ? OR name LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
    people_count =  @people.count
    @people = @people.order(created_at: :desc).page(params[:page]||1).per(params[:per]||25)
    people_ids = @people.map { |e| e.id  }
    encounters_group_by_person_id = ::Hospital::Encounter.where( "person_id" => people_ids, "author_id"=> current_user.id).group_by {|e| e.person_id.to_s}
    people_info = @people.map do |_person|
      _person_info = _person.to_web_front
      _person_info[:encounters_count] = (encounters_group_by_person_id[_person.id.to_s]||[]).count
      # _person_info[:encounter_data] = (encounters_group_by_person_id[_person.id.to_s]||[]).map { |_encounter| _encounter.to_web_front  }
      _person_info
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: people_info, count: people_count} }
    end
	end
  
	# GET
  # /hospital/patients/:id
	def show
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @encounter.to_web_front} }
    end
	end

  # 根据person_id 获取操作员对这个患者的所有就诊历史
  # GET /hospital/patients/get_encounters_by_person_id
  # {person_id: String}
  # 返回参数 {flag: Boolean, info: String, data: Array, count: Integer}
  def get_encounters_by_person_id
    @encounters = ::Hospital::Encounter.where(person_id: params[:person_id], author_id: current_user.id).map { |e| e.to_web_front  }
    if @encounters.blank?
      render json: {flag: false, info: "没有获取到就诊数据", data: [], count: 0}
    else
      render json: {flag: true, info: "", data: @encounters, count: @encounters.count}
    end
  end

  private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end
end

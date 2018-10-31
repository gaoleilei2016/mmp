#encoding:utf-8
#接诊管理、统计
class Hospital::PatientsController < ApplicationController
	before_action :set_cur_org

  # 需要改写方法防止sql注入攻击
  # 根据医生 医生所在机构 查询接诊过的就诊列表
	# GET
  # /hospital/patients
  # {search: String}
	def index
    p "Hospital::PatientsController index", params 
    search = params[:search].to_s
    sql_str =<<SQLSTR
select pp.id from people pp where pp.id=ANY(select he.person_id  from hospital_encounters he where he.author_id=#{current_user.id} and (he.iden like '%#{search}%' or he.phone like '%#{search}%' or he.name like '%#{search}%') group by he.person_id)
SQLSTR
    people_ids = ::Person.find_by_sql(sql_str).map { |e| e.id  }
    people_count =  people_ids.count
    @people = ::Person.where(id: people_ids).order(updated_at: :desc).page(params[:page]||1).per(params[:per]||25)
    # encounters_group_by_person_id = ::Hospital::Encounter.where(hospital_oid: @cur_org.id, "author_id"=> current_user.id).where("iden LIKE ? OR phone LIKE ? OR name LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%").group_by {|e| e.person_id.to_s}
    # encounters_group_by_person_id = ::Hospital::Encounter.where("author_id"=> current_user.id).where("iden LIKE ? OR phone LIKE ? OR name LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%").group_by {|e| e.person_id.to_s}

    people_info = @people.map do |_person|
      _person_info = _person.to_web_front
      # _person_info[:encounters_count] = _person.encounters.count
      _person_info[:encounters_count] = ::Hospital::Encounter.where(hospital_oid: @cur_org.id, "author_id"=> current_user.id, person_id: _person.id).count
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

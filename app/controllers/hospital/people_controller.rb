#encoding:utf-8
#接诊管理、统计
class Hospital::PeopleController < ApplicationController
	before_action :set_encounter, only: [:show, :edit, :update, :destroy, :all_prescriptions]
	# GET
  # /hospital/people
  # 查询人的列表
	def index
    # 查询请求   根据姓名  手机号  身份证号  查询人的信息  如果有 某个时间段的就诊数据就显示出来 没有就显示这个人就行
    # 姓名查询暂时不支持简拼
    p "Hospital::PeopleController index", params
    page = params[:page]||1 # 第几页
    per = params[:per]||25 # 每页参数 多少条数据
    search = params[:search].to_s # 查询字段
    @people = ::Person.where("name LIKE ? OR phone LIKE ? OR iden LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
    count  = @people.count # 满足查询条件的人
    @people = @people.order(updated_at: :desc).page(page).per(per)
    people_ids = @people.map { |e| e.id  }
    # 根据设置 查询当天  某几天的数据
    encounters_group_by_person_id = ::Hospital::Encounter.where( "person_id" => people_ids).where("created_at >= ? ",Time.now.end_of_day - 1.day).group_by {|e| e.person_id.to_s}
    people_info = @people.map do |_person|
      _person_info = _person.to_web_front
      _person_info[:encounter_data] = (encounters_group_by_person_id[_person.id.to_s]||[]).map { |_encounter| _encounter.to_web_front  }
      _person_info
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: people_info, count: count} }
    end
	end
end

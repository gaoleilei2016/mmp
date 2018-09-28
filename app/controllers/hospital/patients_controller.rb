#encoding:utf-8
#接诊管理、统计
class Hospital::PatientsController < ApplicationController
	before_action :set_cur_org
	# GET
  # /hospital/encounters
	def index
    p "Hospital::EncountersController index", params
    search = params[:search].to_s
    @encounters = Hospital::Encounter.where("iden LIKE ? OR phone LIKE ? OR name LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%").order(created_at: :desc).page(params[:page]||1).per(params[:per]||25).map { |e| e.to_web_front  }
    cur_author_patients_count =  @encounters.count
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: @encounters, count: cur_author_patients_count} }
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

  private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end
end

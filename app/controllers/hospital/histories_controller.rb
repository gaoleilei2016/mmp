#encoding:utf-8
#历史记录
class Hospital::HistoriesController < ApplicationController
  before_action :set_cur_org
  before_action :set_cur_encounter
	# GET
  # /hospital/histories
  # 接受encounter_id 查询该就诊人的历史就诊
	def index
    p "Hospital::HistoriesController index", params
    # 只显示当前用户对当前就诊病人看过的历史信息
    # all_encounters = @cur_encounter.person.encounters.map { |_encounter| _encounter.to_web_front  }
    page = params[:page] || 1
    per = params[:per] || 10
    sort = params[:sort] || "DESC"
    all_encounters = ::Hospital::Encounter.get_history_by_doctor(@cur_encounter, @cur_org ,current_user, {page: page, per: per, sort: sort})
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: all_encounters} }
    end
	end

	# GET
  # /hospital/histories/:id
	def show
		render json: {flag: false, info: "暂未支持该功能、如需添加 请联系平台管理员"}
	end

	# GET
  # GET /hospital/histories/new.json
  def new
    render json: {flag: false, info: "暂未支持该功能、如需添加 请联系平台管理员"}
  end

	# GET
  # /hospital/histories/:id/edit
	def edit
    render json: {flag: false, info: "暂未支持该功能、如需添加 请联系平台管理员"}
	end

	# POST
  # /hospital/histories
	def create
    render json: {flag: false, info: "暂未支持该功能、如需添加 请联系平台管理员"}
	end

	# PUT
  # PUT /hospital/histories/:id
  def update
    render json: {flag: false, info: "暂未支持该功能、如需添加 请联系平台管理员"}
  end

	# DELETE
  # /hospital/histories/:id
	def destroy
    render json: {flag: false, info: "暂未支持该功能、如需添加 请联系平台管理员"}
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
end

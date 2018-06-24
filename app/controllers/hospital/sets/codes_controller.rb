class Hospital::Sets::CodesController < ApplicationController
  before_action :set_cur_org
	before_action :set_ini, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/sets/codes
	def index
    p "Hospital::Sets::CodesController index"
    code =  {
      routes: ::Hospital::DictCoding.where(org_id: @cur_org.id, system: "routes"), # 使用途径
      rates: ::Hospital::DictCoding.where(org_id: @cur_org.id, system: "rates"), #频次
      nation: ::Dict::Coding.get_code_by_name("nation"), # 民族
      gender: ::Dict::Coding.get_code_by_name("gender") # 性别
    }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"success", data: code} }
    end
	end

  # POST
  # /hospital/sets/codes
  def create
    render json: {flag: false, info: "暂未支持该功能"}
  end

  # GET
  # /hospital/sets/codes/:id
  def show
    render json: {flag: false, info: "暂未支持该功能"}
  end

  # DELETE
  # /hospital/sets/codes
  def destroy
    render json: {flag: false, info: "暂未支持该功能"}
  end

    # POST
  # /hospital/sets/codes
  def update
    if @code.update_attributes(params[:code])
      render json: {flag: true, info: "success", data: @code}
    else
      render json: {flag: false, info: @code.errors.messages.flatten.join(" ")}
    end
  end

	private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end

    def set_code
      @code = ::Hospital::DictCoding.find(params[:id]) rescue nil
      return render json:{flag:false, info: "无效id 请刷新重试"} if @code.nil?
      return render json:{flag:false, info: "非本机构数据 不能操作"} if @code.ord_id != @cur_org.id
    end
end

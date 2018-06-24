class Hospital::Sets::CodesController < ApplicationController
  before_action :set_cur_org
	before_action :set_ini, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/sets/codes
	def index
    p "Hospital::Sets::CodesController index"
    code =  {
      routes: ::Hospital::DictCoding.where(org_id: @cur_org.id, system: "routes"),
      rates: ::Hospital::DictCoding.where(org_id: @cur_org.id, system: "rates")
    }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"success", data: code} }
    end
	end

	private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end
end

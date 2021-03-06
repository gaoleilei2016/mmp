class Hospital::Sets::InisController < ApplicationController
  before_action :set_cur_org
	before_action :set_ini, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/sets/inis
	def index
    p "Hospital::Sets::InisController index"
    @inis = ::Hospital::Sets::Ini.all rescue []
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: @inis} }
    end
	end

  # GET
  # /hospital/sets/inis/cur_org_ini
  def cur_org_ini
    p "Hospital::Sets::InisController cur_org_ini", params
    @ini = ::Hospital::Sets::Ini.get_org_ini(current_user)
    render json: {flag: true, info:"", data: @ini.to_web_front}
  end
	# GET
  # /hospital/sets/inis/:id
	def show
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @ini.to_web_front} }
    end
	end

	# # GET
 #  # GET /hospital/sets/inis/new.json
 #  def new
 #    @ini = Hospital::Sets::Ini.new
 #    respond_to do |format|
 #      format.html # new.html.erb
 #      format.json { render json: {flag: true, info:"", data: @ini} }
 #    end
 #  end

	# # GET
 #  # /hospital/sets/inis/:id/edit
	# def edit
	# end

	# # POST
 #  # /hospital/sets/inis
	# def create
 #    p "Hospital::Sets::InisController create",params
	# 	@ini = Hospital::Sets::Ini.new(format_ini_create_args)
 #    respond_to do |format|
 #      if @ini.save
 #        format.html { redirect_to @ini, notice: 'ini was successfully created.' }
 #        format.json { render json: {flag: true, info:"", data: @ini.to_web_front} }
 #      else
 #        format.html { render action: "new" }
 #        format.json { render json: {flag: false , info: @ini.errors} }
 #      end
 #    end
	# end

	# PUT
  # PUT /hospital/sets/inis/:id
  def update
    p "Hospital::Sets::InisController update",params
    respond_to do |format|
      if @ini.update_attributes(format_ini_update_args)
        format.json { render json: {flag: true, info:"", data: @ini.to_web_front} }
      else
        format.html { render action: "edit" }
        err_info = ::Hospital.format_errors_message(@ini.class.to_s, @ini.errors.messages)
        format.json { render json: {flag: false , info: err_info.join(" ")} }
      end
    end
  end

	# DELETE
  # /hospital/sets/inis/:id
  #只提供json格式
  def destroy
    p "Hospital::Sets::InisController destroy",params
    respond_to do |format|
      if @ini.status == "N" # 新建状态的可以删除
        if @ini.destroy
          format.json { render json: {flag: true, info: "删除成功"}  }
        else
          format.json { render json: {flag: false, info: "删除失败 #{@ini.errors.messages.values}"}  }
        end
      else
        format.json { render json: {flag: false, info: "删除失败 不是新建状态"}  }
      end
    end
	end

  # 获取本人机构当前人员列表
  def get_org_user_list
    user_list = ::Hospital::Sets::Ini.get_cur_org_users(current_user)
    render json:{flag: true, info: "success", data: user_list}
  end

	private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_ini
      @ini = Hospital::Sets::Ini.find(params[:id]) rescue nil
      return render json:{flag: false, info:"无效基础设置id"} if @ini.nil?
      return render json:{flag: false, info:"不能操作非本人机构以外的数据"} if @ini.org_id != @cur_org.id
    end

    def ini_params
      params[:ini]
    end

    def format_ini_update_args
      ini_args = ini_params
      ret = {
        enable_print_pres: ini_args[:enable_print_pres],
        uoperator_id: current_user.id,
        print_pres_html: ini_args[:print_pres_html],
        prescription_audit_id: (ini_args[:prescription_audit]||{})[:id],
        encounter_search_time: ini_args[:encounter_search_time].to_i
      }
      return ret
    end
end

class Hospital::Sets::CodesController < ApplicationController
  before_action :set_cur_org
	before_action :set_ini, only: [:show, :edit, :update, :destroy]
	# GET
  # /hospital/sets/codes
	def index
    p "Hospital::Sets::CodesController index"
    # @codes = Hospital::Sets::Code.all rescue []
    code =  {
      routes: [{code: "PO", display: "口服", jianpin: "KF"},{code: "IV.DRIP", display: "静脉滴注", jianpin: "JMDZ"},{code: "SC", display: "皮下注射", jianpin: "PXZS"},{code: "IM", display: "肌肉注射", jianpin: "JRZS"},{code: "IV.SHOVE", display: "静脉推注", jianpin: "JMTZ"},{code: "INH", display: "雾化吸入", jianpin: "WHXR"},{code: "JMBR", display: "静脉泵入", jianpin: "JMBR"},{code: "OP", display: "滴眼", jianpin: "DY"},{code: "NA", display: "滴鼻", jianpin: "DB"},{code: "ST", display: "喷喉", jianpin: "PH"},{code: "CHEW", display: "含化", jianpin: "HH"},{code: "ATW", display: "敷伤口", jianpin: "FSK"},{code: "CTS", display: "擦皮肤", jianpin: "CPF"},{code: "RE", display: "直肠用药", jianpin: "ZCYY"},{code: "SL", display: "舌下用药", jianpin: "SXYY"},{code: "INJP", display: "注射用药", jianpin: "ZSYY"},{code: "ID", display: "皮内注射", jianpin: "PNZS"},{code: "IV", display: "静脉注射", jianpin: "JMZS"},{code: "IN", display: "吸入用药", jianpin: "XRYY"},{code: "LA", display: "局部用药", jianpin: "JBYY"},{code: "SCM", display: "椎管内用药", jianpin: "ZGNYY"},{code: "ACD", display: "关节腔内用药", jianpin: "GJQNYY"},{code: "PCM", display: "胸膜腔用药", jianpin: "XMQYY"},{code: "IP", display: "腹腔用药", jianpin: "FQYY"},{code: "VA", display: "阴道用药", jianpin: "YDYY"},{code: "EM", display: "气管内用药", jianpin: "QGNYY"},{code: "ODW", display: "其他用药途径", jianpin: "QTYYTJ"}],
      rates: [{code: "QD", display: "每日一次", jianpin: "MRYC"}, {code: "BID", display: "每日两次", jianpin: "MRLC"}, {code: "TID", display: "每日三次", jianpin: "MRSC"}, {code: "QID", display: "每日四次", jianpin: "MRSC"}, {code: "QUINGID", display: "每日五次", jianpin: "MRWC"}, {code: "QN", display: "每晚一次", jianpin: "MWYC"}, {code: "Q4H", display: "四小时一次", jianpin: "SXSYC"}, {code: "Q6H", display: "六小时一次", jianpin: "LXSYC"}, {code: "Q8H", display: "八小时一次", jianpin: "BXSYC"}, {code: "Q12H12", display: "小时一次", jianpin: "XSYC"}, {code: "QH", display: "一小时一次", jianpin: "YXSYC"}, {code: "Q2H", display: "二小时一次", jianpin: "EXSYC"}, {code: "Q3H", display: "三小时一次", jianpin: "SXSYC"}, {code: "QOD", display: "隔日一次", jianpin: "GRYC"}, {code: "QW", display: "每周一次", jianpin: "MZYC"}],
    }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: code} }
    end
	end

  # GET
  # /hospital/sets/codes/cur_org_ini
  def cur_org_ini
    p "Hospital::Sets::CodesController cur_org_ini", params
    @ini = Hospital::Sets::Code.get_org_ini(current_user)
    render json: {flag: true, info:"", data: @ini.to_web_front}
  end
	# GET
  # /hospital/sets/codes/:id
	def show
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @ini.to_web_front} }
    end
	end

	# # GET
 #  # GET /hospital/sets/codes/new.json
 #  def new
 #    @ini = Hospital::Sets::Code.new
 #    respond_to do |format|
 #      format.html # new.html.erb
 #      format.json { render json: {flag: true, info:"", data: @ini} }
 #    end
 #  end

	# # GET
 #  # /hospital/sets/codes/:id/edit
	# def edit
	# end

	# # POST
 #  # /hospital/sets/codes
	# def create
 #    p "Hospital::Sets::CodesController create",params
	# 	@ini = Hospital::Sets::Code.new(format_ini_create_args)
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
  # PUT /hospital/sets/codes/:id
  def update
    p "Hospital::Sets::CodesController update",params
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
  # /hospital/sets/codes/:id
  #只提供json格式
  def destroy
    p "Hospital::Sets::CodesController destroy",params
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
    user_list = ::Hospital::Sets::Code.get_cur_org_users(current_user)
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
      @ini = Hospital::Sets::Code.find(params[:id]) rescue nil
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

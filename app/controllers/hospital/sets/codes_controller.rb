class Hospital::Sets::CodesController < ApplicationController
 #  before_action :set_cur_org
	# before_action :set_ini, only: [:show, :edit, :update, :destroy]

  # 查询数据全部来源于 编码表 dictdata
  # 暂时查询统一编码表的数据  后面更具需求提供自定义方式
	# GET
  # /hospital/sets/codes 
	def index
    p "Hospital::Sets::CodesController index"
    code =  {
      routes: ::Dict::Coding.get_code_by_system("2.16.156.1.13610.1.364.6.0.102"), # 使用途径
      rates: ::Dict::Coding.get_code_by_system("2.16.156.1.675425699.1.191"), #频次
      nations: ::Dict::Coding.get_code_by_system("2.16.156.1.19449.1.3304"), # 民族
      gender: ::Dict::Coding.get_code_by_system("2.16.156.1.19449.1.2261.1"), # 性别
      marriages: ::Dict::Coding.get_code_by_system("2.16.156.1.19449.1.2261.2"), # 婚姻
      occupations: ::Dict::Coding.get_code_by_system("2.16.156.1.13610.1.364.2.1.202"), #职业
      prescription_types: ::Dict::Coding.get_code_by_system("2.16.156.1.675425699.1.50"), # 处方类型
      bloods: ::Dict::Coding.get_code_by_system("2.16.156.1.13610.1.364.4.50.5"), # 血型
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
    render json: {flag: false, info: "暂未支持该功能 如需修改 请联系管理员"}
    # if @code.update_attributes(params[:code])
    #   render json: {flag: true, info: "success", data: @code}
    # else
    #   render json: {flag: false, info: "#{@code.errors.messages}"}
    # end
  end

  # 根据编码系统oid 获取编码系统编码数据
  # GET
  # /hospital/sets/codes/get_code_by_system
  # 接受参数 {system: String}
  # 返回格式 {flag: Boolean, info: String, data: Array}
  def get_code_by_system
    return render json: {flag: false, info: "编码系统system不能为空", data: []} if params[:system].blank?
    data = ::Dict::Coding.get_code_by_system(params[:system])
    if data.blank?
      ret = {flag: false, info: "没有查询到编码信息", data: []}
    else
      ret = {flag: true, info: "success", data: data}
    end
    render json: ret
  end

	private
    # 获取当前机构 没有就提示
    # def set_cur_org
    #   @cur_org =  current_user.organization
    #   return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    # end

    # def set_code
    #   @code = ::Hospital::DictCoding.find(params[:id]) rescue nil
    #   return render json:{flag:false, info: "无效id 请刷新重试"} if @code.nil?
    #   return render json:{flag:false, info: "非本机构数据 不能操作"} if @code.ord_id != @cur_org.id
    # end
end

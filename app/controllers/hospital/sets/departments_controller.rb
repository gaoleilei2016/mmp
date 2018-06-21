class ::Hospital::Sets::DepartmentsController < ApplicationController
  before_action :set_cur_org
  before_action :set_department, only: [:show, :edit, :update, :destroy]


  # 根据当前用户的机构id获取机构科室列表
	# GET
  # /hospital/sets/departments
	def index
    p "Hospital::Sets::DepartmentsController index"
    search = params[:search].to_s
    departments_count = ::Hospital::Sets::Department.where("org_id=?", @cur_org.id).count
    @departments = ::Hospital::Sets::Department.where("org_id=? AND name LIKE ?", @cur_org.id, "%#{search}%") rescue []
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"success", data: @departments, count: departments_count} }
    end
	end

	# GET
  # /hospital/sets/departments/:id
	def show
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"success", data: @department} }
    end
	end

  # GET
  # /hospital/sets/departments/get_active_departments
  # 获取本机构当前有效的科室列表
  def get_active_departments
    search = params[:search].to_s
    @departments = ::Hospital::Sets::Department.where("org_id=? AND name LIKE ? AND status='A'", @cur_org.id, "%#{search}%") rescue []
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"success", data: @departments} }
    end
  end

  # POST
  # /hospital/sets/departments/set_cur_department
  # 设置当前医生操作者的当前科室
  # {
  #   dep_id: 
  # }
  def set_cur_department
    current_user.cur_loc_id = params[:dep_id]
    current_user.cur_loc_display = ::Hospital::Sets::Department.find(params[:dep_id]).name
    respond_to do |format|
      if current_user.save
        format.json { render json: {flag: true, info:"success", data: {id: current_user.cur_loc_id, display: current_user.cur_loc_display}} }
      else
        format.json { render json: {flag: false , info: current_user.errors.message.values.flatten} }
      end
    end    
  end

	# POST
  # /hospital/sets/departments
	def create
    p "Hospital::Sets::DepartmentsController create",params
		@department = ::Hospital::Sets::Department.new(format_department_create_args)
    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: 'department was successfully created.' }
        format.json { render json: {flag: true, info:"success", data: @department} }
      else
        format.html { render action: "new" }
        format.json { render json: {flag: false , info: @department.errors} }
      end
    end
	end

	# PUT
  # PUT /hospital/sets/department/:id
  def update
    p "Hospital::Sets::DepartmentsController update",params
    respond_to do |format|
      if @department.update_attributes({name: params[:department][:name]})
        format.json { render json: {flag: true, info:"success", data: @department} }
      else
        format.html { render action: "edit" }
        format.json { render json: {flag: false , info: @department.errors} }
      end
    end
  end

	# DELETE
  # /hospital/sets/department/:id
  #只提供json格式
  def destroy
    p "Hospital::Sets::DepartmentsController destroy",params
    @department.update_attributes(status: "O")
    render json: {flag: true, info: "success", data: @department}
	end

	private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end

    # 获取科室信息 且获取的科室一定是当前操作哲机构的
    def set_department
      @department = ::Hospital::Sets::Department.find(params[:id]) rescue nil
      return render json:{flag: false, info:"无效的科室id"} if @department.nil?
      return render json:{flag: false, info:"不能操作非本人机构以外的科室数据"} if @department.org_id != @cur_org.id 
    end

    def department_params
      params[:department]
    end

    def format_department_create_args
      department_args = department_params
      ret = {
        org_id: @cur_org.id,
        name: department_args[:name],
        jianpin: nil,
        status: "A",
      }
      return ret
    end
end

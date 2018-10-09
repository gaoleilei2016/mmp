#encoding:utf-8
#医嘱模板
class ::Hospital::Sets::MtemplatesController < ApplicationController
  before_action :set_cur_org
  before_action :set_cur_dep
  before_action :set_mtemplate, only: [:show, :edit, :update, :destroy]
  before_action :change?, only: [:edit, :update, :destroy]
  # GET
  # /hospital/sets/mtemplates
  def index
    p "index", params
    search_str = params[:search].to_s
    page = params[:page] || 1
    per = params[:per] || 25
    case params[:type].to_s
    when "0" # 自己创建的 
      @mtemplates = ::Hospital::Sets::Mtemplate.where("author_id=? AND title LIKE ?", current_user.id,"%#{search_str}%")
    when "1" # 科室共享的
      @mtemplates = ::Hospital::Sets::Mtemplate.where("sharing_scope_code='1' AND location_id=? AND title LIKE ?", @cur_dep.id,"%#{search_str}%")
    when "2" # 医院共享的
      cur_org = current_user.organization
      @mtemplates = ::Hospital::Sets::Mtemplate.where("sharing_scope_code='2' AND org_id=? AND title LIKE ?", @cur_org.id,"%#{search_str}%")
    when "available" # 可以使用的
      @mtemplates = ::Hospital::Sets::Mtemplate.where("(author_id=? AND title LIKE ?) 
        OR (sharing_scope_code='1' AND location_id=? AND title LIKE ?) 
        OR (sharing_scope_code='2' AND org_id=? AND title LIKE ?)", 
        current_user.id, "%#{search_str}%", @cur_dep.id, "%#{search_str}%", @cur_org.id, "%#{search_str}%")
    else
      return render json: {flag: false, info:"暂未支持该方法"}
    end
    @mtemplate_info =  @mtemplates.page(page).per(per).map { |e|  e.to_web_front}
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"success", data: @mtemplate_info, count: @mtemplates.count} }
    end
  end

  # GET
  # /hospital/sets/mtemplates/:id
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"success", data: @mtemplate.to_web_front} }
    end
  end

  # # GET
  # # GET /hospital/sets/mtemplates/new.json
  # def new
  #   @mtemplate = ::Hospital::Sets::Mtemplate.new
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: {flag: true, info:"", data: @mtemplate} }
  #   end
  # end

  # # GET
  # # /hospital/sets/mtemplates/:id/edit
  # def edit
  # end

  # POST
  # /hospital/sets/mtemplates
  def create
    p "/hospital/sets/mtemplates create", params
    create_data = format_mtemplate_create_args
    @mtemplate = ::Hospital::Sets::Mtemplate.new(create_data[:mtemplate])
    respond_to do |format|
      if @mtemplate.save
        ::Hospital::Order.to_template_order(create_data[:order_ids], @mtemplate.id, current_user)
        format.html { redirect_to @mtemplate, notice: 'mtemplate was successfully created.' }
        format.json { render json: {flag: true, info:"", data: @mtemplate.to_web_front} }
      else
        format.html { render action: "new" }
        err_info = ::Hospital.format_errors_message(@mtemplate.class.to_s, @mtemplate.errors.messages)
        format.json { render json:{flag: false, info: err_info.join(" ")} }
      end
    end
  end

  # PUT
  # PUT /hospital/sets/mtemplates/:id
  def update
    p "/hospital/sets/mtemplates create", params
    update_data = format_mtemplate_update_args
    respond_to do |format|
      if @mtemplate.update_attributes(update_data[:mtemplate])
        ::Hospital::Order.to_template_order(update_data[:order_ids], @mtemplate.id, current_user)
        format.html { redirect_to @mtemplate, notice: 'mtemplate was successfully updated.' }
        format.json { render json: {flag: true, info:"", data: @mtemplate.to_web_front} }
      else
        format.html { render action: "edit" }
        err_info = ::Hospital.format_errors_message(@mtemplate.class.to_s, @mtemplate.errors.messages)
        format.json { render json:{flag: false, info: err_info.join(" ")} }
      end
    end
  end

  # DELETE
  # /hospital/sets/mtemplates/:id
  def destroy
    respond_to do |format|
      if @mtemplate.update_attributes(status: "O")
        format.json { render json: {flag: true, info: "success", data: @mtemplate} }
      else
        err_info = ::Hospital.format_errors_message(@mtemplate.class.to_s, @mtemplate.errors.messages)
        format.json { render json:{flag: false, info: err_info.join(" ")} }
      end
    end
  end

  # 接诊时 引用事先创建好的模板
  # POST
  # /hospital/sets/mtemplates/quote_template
  # {encounter_id: Hospital::Encounter#id, template_id: ::Hospital::Sets::Mtemplate#id}
  def quote_template
    p " quote_template",params
    return render json: {flag: false, info: "引用失败：没有就诊id"} if params[:encounter_id].blank?
    return render json: {flag: false, info: "引用失败：没有模板id"} if params[:template_id].blank?
    order_ids = ::Hospital::Order.select(:id).where(mtemplate_id: params[:template_id]).map { |e| e.id  }
    ret = ::Hospital::Order.copy_orders(order_ids, params[:encounter_id], current_user)
    info = ret[:flag] ? "引用成功" : ("引用失败: " + ret[:info]) 
    render json: {flag: ret[:flag], info: info}
  end

  private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end

    # 获取当前科室 没有就提示
    def set_cur_dep
      @cur_dep =  ::Hospital::Sets::Department.find(current_user.cur_loc_id) rescue nil
      return render json:{flag:false, info: "当前用户没有设置当前科室 请设置当前科室后再重试"} if @cur_dep.nil?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_mtemplate
      @mtemplate = ::Hospital::Sets::Mtemplate.find(params[:id]) rescue nil
      return render json:{flag: false, info:"无效的模板id"} if @mtemplate.nil?
      return render json:{flag: false, info:"不能操作非本人机构以外的模板数据"} if @mtemplate.org_id != @cur_org.id
    end

    def change?
      flag = @mtemplate.author_id == current_user.id ? true : false
      return render json:{flag: false, info: "不能操作非本人创建的模板"} if !flag
    end

    def mtemplate_params
      params[:mtemplate]
    end

    def format_mtemplate_create_args
      args = mtemplate_params
      mtemplate_info = {
        org_id: current_user.organization.id,
        status: "A",
        title: args[:title],
        note: args[:note],
        sharing_scope_code: args[:sharing_scope][:code],
        sharing_scope_display: args[:sharing_scope][:display],
        disease_code: args[:disease][:code],
        disease_display: args[:disease][:display],
        author_id: current_user.id,
        author_display: current_user.name,
        location_id: @cur_dep.id,
        location_display: @cur_dep.name
      }
      ret = {
        mtemplate: mtemplate_info,
        order_ids: args[:order_ids]||[]
      }
    end

    def format_mtemplate_update_args
      args = mtemplate_params
      mtemplate_info = {
        org_id: current_user.organization.id,
        status: "A",
        title: args[:title],
        note: args[:note],
        sharing_scope_code: args[:sharing_scope][:code],
        sharing_scope_display: args[:sharing_scope][:display],
        disease_code: args[:disease][:code],
        disease_display: args[:disease][:display],
        author_id: current_user.id,
        author_display: current_user.name,
        location_id: @cur_dep.id,
        location_display: @cur_dep.name
      }
      ret = {
        mtemplate: mtemplate_info,
        order_ids: args[:order_ids] || []
      }
    end
end

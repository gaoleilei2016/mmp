#encoding:utf-8
#医嘱模板
class Hospital::Sets::MtemplatesController < ApplicationController
  before_action :set_mtemplate, only: [:show, :edit, :update, :destroy]
  # GET
  # /hospital/sets/mtemplates
  def index
    search_str = params[:search]
    case params[:type].to_s
    when "0" # 自己创建的 
      @mtemplates = Hospital::Sets::Mtemplate.where("author_id=? AND title LIKE ?", current_user.id,"%#{search_str}%").page(params[:page]||1).per(params[:per]||25)
    when "1" # 科室共享的
      cur_dep = current_user.current_dep
      @mtemplates = Hospital::Sets::Mtemplate.where("sharing_scope_code='1' AND location_id=? AND title LIKE ?", cur_dep.id,"%#{search_str}%").page(params[:page]||1).per(params[:per]||25)
    when "2" # 医院共享的
      cur_org = current_user.organizations
      @mtemplates = Hospital::Sets::Mtemplate.where("sharing_scope_code='2' AND organization_id=? AND title LIKE ?", cur_org.id,"%#{search_str}%").page(params[:page]||1).per(params[:per]||25)
    when "avaliable" # 可以使用的
      @mtemplates = Hospital::Sets::Mtemplate.all.page(params[:page]||1).per(params[:per]||25)
    else
      return render json: {flag: true, info:"success", data: @mtemplates}
    end
    @mtemplates =  @mtemplates.map { |e|  e.to_web_front}
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"success", data: @mtemplates} }
    end
  end

  # GET
  # /hospital/sets/mtemplates/:id
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @mtemplate} }
    end
  end

  # GET
  # GET /hospital/sets/mtemplates/new.json
  def new
    @mtemplate = Hospital::Sets::Mtemplate.new
   
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {flag: true, info:"", data: @mtemplate} }
    end
  end

  # GET
  # /hospital/sets/mtemplates/:id/edit
  def edit
  end

  # POST
  # /hospital/sets/mtemplates
  def create
    p "/hospital/sets/mtemplates create", params
    create_data = format_mteplate_create_args
    @mtemplate = Hospital::Sets::Mtemplate.new(create_data[:mteplate])
    respond_to do |format|
      if @mtemplate.save
        ::Hospital::Order.to_template_order(create_data[:order_ids], @mtemplate.id, current_user)
        format.html { redirect_to @mtemplate, notice: 'mtemplate was successfully created.' }
        format.json { render json: {flag: true, info:"", data: @mtemplate} }
      else
        format.html { render action: "new" }
        format.json { render json: @mtemplate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT
  # PUT /hospital/sets/mtemplates/:id
  def update

    respond_to do |format|
      if @mtemplate.update_attributes(params[:mtemplate])
        format.html { redirect_to @mtemplate, notice: 'mtemplate was successfully updated.' }
        format.json { render json: {flag: true, info:"", data: @mtemplate} }
      else
        format.html { render action: "edit" }
        format.json { render json: @mtemplate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE
  # /hospital/sets/mtemplates/:id
  def destroy
    @mtemplate.update_attributes(status: "O")
    respond_to do |format|
      format.html { redirect_to histories_url }
      format.json { render json: {flag: true, info: "success", data: @mtemplate} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mtemplate
      @mtemplate = Hospital::Sets::Mtemplate.find(params[:id])
    end

    def mtemplate_params
      params[:mtemplate]
    end

    def format_mteplate_create_args
      args = mtemplate_params
      mteplate_info = {
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
        location_id: 1,
        location_display: "酱油科"
      }
      ret = {
        mteplate: mteplate_info,
        order_ids: args[:order_ids]
      }
    end
end

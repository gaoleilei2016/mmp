# 用于医生端的
# Hospital::Dict::NewMedication 是关联数据库中的new_dictmedicine视图的
# Dict::Medication 是药品字典的表
class ::Hospital::Dict::NewMedicationsController < ApplicationController
  before_action :set_cur_org

  rescue_from RuntimeError do |exception|
    respond_to do |f|
      f.html {render xml:{flag:false,reason:exception.class.to_s,info:exception.message}}
      f.json {render json:{flag:false,reason:exception.class.to_s,info:exception.message}}
    end
  end

  # GET
  # hospital/dict/medications
  def index
    p "::Dict::MedicationsController index", params
    p current_user,@cur_org
    serialno = params[:search]
    ecode = params[:search]
    name = params[:search]
    common_name = params[:search]
    alias_name = params[:search]
    py = params[:search]
    wb = params[:search]
    common_py = params[:search]
    common_wb = params[:search]
    alias_py = params[:search]
    alias_wb = params[:search]
    search_str = "serialno LIKE ? OR ecode LIKE ? OR name LIKE ? OR common_name LIKE ? OR alias_name LIKE ? OR py LIKE ? OR wb LIKE ? OR common_py LIKE ? OR common_wb LIKE ? OR alias_py LIKE ? OR alias_wb LIKE ?"
    @medications = ::Hospital::Dict::NewMedication.where(hos_id: @cur_org.id).where(search_str, "%#{serialno}%", "%#{ecode}%", "%#{name}%", "%#{common_name}%", "%#{alias_name}%", "%#{py}%", "%#{wb}%", "%#{common_py}%", "%#{common_wb}%", "%#{alias_py}%", "%#{alias_wb}%").page(params[:page]||1).per(params[:per]||25)
    ret = @medications.map { |e| e.to_hash }
      respond_to do |format|
        if ret.blank?
          format.json { render json: {flag: false, info: "没有相关药品", data: ret} }
        else
          format.html # index.html.erb
          format.json { render json: {flag: true, info:"", data: ret} }
        end
      end
  end

  # GET
  # hospital/dict/medications/:id
  def show
    @medication = ::Hospital::Dict::NewMedication.find(params[:id])
    # 获取该药品的实时库存量
    @medication = @medication.to_hash
    render json:{flag: true, info: "success", data: @medication}
  end

  private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end
end
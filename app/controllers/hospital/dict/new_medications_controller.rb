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
  # hospital/dict/new_medications
  def index
    p "::Dict::MedicationsController index", params
    serialno, ecode, name, common_name, alias_name, py, wb, common_py, common_wb, alias_py, alias_wb = Array.new(11, params[:search]) # 11是等号左边变量的数目
    p current_user,@cur_org
    search_str = "serialno LIKE ? OR ecode LIKE ? OR name LIKE ? OR common_name LIKE ? OR alias_name LIKE ? OR py LIKE ? OR wb LIKE ? OR common_py LIKE ? OR common_wb LIKE ? OR alias_py LIKE ? OR alias_wb LIKE ?"
    @medications = ::Hospital::Dict::NewMedication.where(hos_id: @cur_org.id).where(search_str, "%#{serialno}%", "%#{ecode}%", "%#{name}%", "%#{common_name}%", "%#{alias_name}%", "%#{py}%", "%#{wb}%", "%#{common_py}%", "%#{common_wb}%", "%#{alias_py}%", "%#{alias_wb}%").page(params[:page]||1).per(params[:per]||25)
    med_count = @medications.count
    ret = @medications.map { |e| e.to_hash }
    respond_to do |format|
      if ret.blank?
        format.json { render json: {flag: false, info: "没有相关药品", data: ret, count: med_count} }
      else
        format.html # index.html.erb
        format.json { render json: {flag: true, info:"", data: ret, count: med_count} }
      end
    end
  end

  # GET
  # hospital/dict/new_medications/:id
  def show
    @medication = ::Hospital::Dict::NewMedication.find(params[:id])
    # 获取该药品的实时库存量
    @medication = @medication.to_hash
    render json:{flag: true, info: "success", data: @medication}
  end

  # 医生端 药品列表
  # GET
  # hospital/dict/new_medications/list
  # {search: String, pharmacology_code: String, indications: Array}
  def list
    p "::Dict::MedicationsController index", params
    serialno,ecode,name,common_name,alias_name,py,wb,common_py,common_wb,alias_py,alias_wb = Array.new(11, params[:search]) # 11是等号左边变量的数目
    p current_user,@cur_org
    search_str = "serialno LIKE ? OR ecode LIKE ? OR name LIKE ? OR common_name LIKE ? OR alias_name LIKE ? OR py LIKE ? OR wb LIKE ? OR common_py LIKE ? OR common_wb LIKE ? OR alias_py LIKE ? OR alias_wb LIKE ?"
    # 基础查询 根据
    @medications = ::Hospital::Dict::NewMedication.where(hos_id: @cur_org.id).where(search_str, "%#{serialno}%", "%#{ecode}%", "%#{name}%", "%#{common_name}%", "%#{alias_name}%", "%#{py}%", "%#{wb}%", "%#{common_py}%", "%#{common_wb}%", "%#{alias_py}%", "%#{alias_wb}%")
    # 药理学分类查询
    if params[:pharmacology_code].present?
      pharmacology_code = params[:pharmacology_code] # 药理学分类
      @medications = @medications.where(pharmacology_code: params[:pharmacology_code])
    end
    if params[:indications].present?
      indications = params[:indications].map { |e| "%#{e}%"  } # 适应症
      indications_search_str = indications.map {|e| "indications LIKE ?" }.join(" OR ")
      indications_search_arr = [indications_search_str] + indications
      @medications = @medications.where(indications_search_arr)
    end
    med_count = @medications.count
    @medications = @medications.page(params[:page]||1).per(params[:per]||25)
    ret = @medications.map { |e| e.to_hash }
    respond_to do |format|
      if ret.blank?
        format.json { render json: {flag: false, info: "没有相关药品", data: ret, count: med_count} }
      else
        format.html # index.html.erb
        format.json { render json: {flag: true, info:"", data: ret, count: med_count} }
      end
    end
  end

  private
    # 获取当前机构 没有就提示
    def set_cur_org
      @cur_org =  current_user.organization
      return render json:{flag:false, info: "当前用户没有分配机构 请分配机构后再重试"} if @cur_org.nil?
    end
end
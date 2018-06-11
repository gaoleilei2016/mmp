class ::Dict::MedicationsController < ApplicationController

  # GET
  # /dict/diseases
  def index
    p "::Dict::MedicationsController index", params
    params[:search] = "nl"
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
    @diseases = ::Dict::Medication.where(search_str, "%#{serialno}%", "%#{ecode}%", "%#{name}%", "%#{common_name}%", "%#{alias_name}%", "%#{py}%", "%#{wb}%", "%#{common_py}%", "%#{common_wb}%", "%#{alias_py}%", "%#{alias_wb}%").page(params[:page]||1).per(params[:per]||25)
    ret = @diseases.map { |e| e.to_hash }
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: {flag: true, info:"", data: ret} }
      end
  end
end
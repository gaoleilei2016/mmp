#encoding:utf-8
#接诊管理、统计
class Hospital::PatientsController < ApplicationController
	before_action :set_encounter, only: [:show, :edit, :update, :destroy, :all_prescriptions]
	# GET
  # /hospital/encounters
	def index
    p "Hospital::EncountersController index", params
    search = params[:search].to_s
    cur_author_patients_count =  Hospital::Encounter.count
		@encounters = Hospital::Encounter.where("iden LIKE ? OR phone LIKE ? OR name LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%").order(created_at: :desc).page(params[:page]||1).per(params[:per]||25).map { |e| e.to_web_front  }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {flag: true, info:"", data: @encounters, count: cur_author_patients_count} }
    end
	end
  
	# GET
  # /hospital/encounters/:id
	def show
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {flag: true, info:"", data: @encounter.to_web_front} }
    end
	end
end

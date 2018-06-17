#encoding:utf-8
# 诊断控制器
class Hospital::DiagnosesController < ApplicationController
	before_action :set_diagnose, only: [:show, :edit, :update, :destroy]





	# POST
	# 根据就诊id 诊断数据  创建诊断 并与就诊的关联
	# /hospital/diagnoses/create_by_encounter_id
	# {
	# 	encounter_id: 
	# 	code: 
	# 	display: 
	# }
	def create_by_encounter_id
		@diagnose = ::Hospital::Diagnose.new(params[:diagnose])
		if @diagnose.save
			render json: {flag: true, info: "success", data: @diagnose}
		else
			render json: {flag: false, info: @diagnose.errors.message.values.flatten}
		end
	end


	# GET
	# /hospital/diagnoses/:id
	def show
		render json: {flag: true, info: "success", data: @diagnose}
	end

	# DELETE
	# /hospital/diagnoses/:id
	def destroy
		if @diagnose.destroy
			render json: {flag: true, info: "success", data: @diagnose}
		else
			render json: {flag: false, info: @diagnose.errors.message.values.flatten, data: @diagnose}
		end
	end


	# GET
	# 根据就诊id 查询诊断
	# /hospital/diagnoses/get_diagnoses_by_encounter_id
	# {
	# 	encounter_id: Hospital::Encounter.id
	# }
	def get_diagnoses_by_encounter_id
		@diagnoses = ::Hospital::Diagnose.where("encounter_id" => params[:encounter_id]).order(:rank)
		render json: {flag: true, info: "success", data: @diagnoses}
	end

	private
		# Use callbacks to share common setup or constraints between actions.
	  def set_diagnose
	    @diagnose = Hospital::Diagnose.find(params[:id])
	  end
end
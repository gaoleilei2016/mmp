#encoding:utf-8
# 诊断控制器
class Hospital::DiagnosesController < ApplicationController
	before_action :set_diagnose, only: [:show, :edit, :update, :destroy]



	# GET
	# 根据就诊id返回诊断
	# 只能通过就诊id
	# /hospital/diagnoses
	def index
		@diagnoses = ::Hospital::Diagnose.where(encounter_id: params[:encounter_id]).order(:type_code).order(:rank)
		ret = ::Hospital::Diagnose.to_master_and_slaver(@diagnoses)
		@all_diagnoses = ret[:master] + ret[:slaver]
		render json: {flag:true, info: "success", master: ret[:master], data: @all_diagnoses}
	end

	# POST
	# 根据就诊id 诊断数据  创建诊断 并与就诊的关联
	# /hospital/diagnoses
	# {
	# 	encounter_id: 
	# 	code: 
	# 	display: 
	# }
	def create
		@diagnose = ::Hospital::Diagnose.new(format_encounter_diagnose_create_args)
		@diagnose.set_rank
		if @diagnose.save
			@diagnoses = ::Hospital::Diagnose.where(encounter_id: params[:encounter_id]).order(:type_code).order(:rank)
			ret = ::Hospital::Diagnose.to_master_and_slaver(@diagnoses)
			render json: {flag: true, info: "success", master: ret[:master], data: @diagnose.to_web_front}
		else
			render json: {flag: false, info: @diagnose.errors.message.values.flatten}
		end
	end

	# POST
	# 根据诊断id 和
	# /hospital/diagnoses/sort
	def sort
		p "Hospital::DiagnosesController" , params
		# tag_id 是被操作   exchange_id 被更换的是
		case params[:sort].to_s
		when "1" # 上移
			ret = ::Hospital::Diagnose.swap(params[:tag_id], params[:exchange_id])
			@diagnoses = ::Hospital::Diagnose.where(encounter_id: params[:encounter_id]).order(:type_code).order(:rank)
			all_ret = ::Hospital::Diagnose.to_master_and_slaver(@diagnoses)
			render json: {flag: ret[:flag], info: ret[:info], master: all_ret[:master]}
		when "-1" # 下移
			ret = ::Hospital::Diagnose.swap(params[:tag_id], params[:exchange_id])
			@diagnoses = ::Hospital::Diagnose.where(encounter_id: params[:encounter_id]).order(:type_code).order(:rank)
			all_ret = ::Hospital::Diagnose.to_master_and_slaver(@diagnoses)
			render json: {flag: ret[:flag], info: ret[:info], master: all_ret[:master]}
		else
			render json: {flag: false, info: "暂不支持该功能"}
		end
	end

	# GET
	# /hospital/diagnoses/:id
	def show
		# render json: {flag: true, info: "success", data: @diagnose.to_web_front}
		render json: {flag: false, info: "暂不支持该功能"}
	end

	# PUT
	# /hospital/diagnoses/:id
	def update
		respond_to do |format|
	    if @diagnose.update_attributes(format_encounter_diagnose_update_args)
	    	@diagnoses = ::Hospital::Diagnose.where(encounter_id: params[:encounter_id]).order(:type_code).order(:rank)
				all_ret = ::Hospital::Diagnose.to_master_and_slaver(@diagnoses)
	    	format.html { redirect_to @diagnose, notice: 'diagnose was successfully updated.'}
	    	format.json { render json: {flag: true, info:"", master: all_ret[:master], data: @diagnose.to_web_front} }
	    else
	    	format.html { render action: "edit" }
	    	format.json { render json: @diagnose.errors, status: :unprocessable_entity }
	    end
	  end
	end

	# DELETE
	# /hospital/diagnoses/:id
	def destroy
		if @diagnose.destroy
			@diagnoses = ::Hospital::Diagnose.where(encounter_id: params[:encounter_id]).order(:type_code).order(:rank)
			ret = ::Hospital::Diagnose.to_master_and_slaver(@diagnoses)
			@all_diagnoses = ret[:master] + ret[:slaver]
			render json: {flag: true, info: "success", master: ret[:master], slaver: ret[:slaver], data: @all_diagnoses}
		else
			render json: {flag: false, info: @diagnose.errors.message.values.flatten, data: @diagnose.to_web_front}
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
	  def set_diagnose
	    @diagnose = Hospital::Diagnose.find(params[:id])
	  end

	  def diagnose_params
	  	params[:diagnosis]
	  end

	  def format_encounter_diagnose_create_args
	  	args = diagnose_params
	  	ret = {
				code: args[:code],
				display: args[:display],
				system: args[:system],				
				status: "A",
				encounter_id: params[:encounter_id],
				doctor_id: args[:doctor_id]||current_user.id,
				type_code: args[:type][:code],
				type_display: args[:type][:display],
				note: args[:note],
				fall_ill_at: args[:fall_ill_at]
	  	}
	  	return ret
	  end

	  def format_encounter_diagnose_update_args
	  	args = diagnose_params
	  	ret = {
	  		code: args[:code],
				display: args[:display],
				system: args[:system],				
				encounter_id: params[:encounter_id],
				doctor_id: args[:doctor_id]||current_user.id,
				type_code: args[:type][:code],
				type_display: args[:type][:display],
				note: args[:note],
				status: args[:status],
				fall_ill_at: args[:fall_ill_at]
	  	}
	  	return ret
	  end
end
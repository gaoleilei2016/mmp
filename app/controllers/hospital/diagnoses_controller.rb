#encoding:utf-8
# 诊断控制器
class Hospital::DiagnosesController < ApplicationController
  before_action :set_cur_org
  before_action :set_cur_dep
  before_action :set_cur_encounter
  before_action :set_diagnose, only: [:edit, :update, :destroy]
  before_action :change?, only: [:edit, :update, :destroy]
  before_action :can_sort?, only: [:sort]

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
		p "create",params
		@diagnose = ::Hospital::Diagnose.new(format_encounter_diagnose_create_args)
		@diagnose.set_rank
		if @diagnose.save
			@diagnoses = ::Hospital::Diagnose.where(encounter_id: params[:encounter_id]).order(:type_code).order(:rank)
			ret = ::Hospital::Diagnose.to_master_and_slaver(@diagnoses)
			render json: {flag: true, info: "success", master: ret[:master], data: @diagnose.to_web_front}
		else
			render json: {flag: false, info: "#{@diagnose.errors.messages}"}
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
			update_data = format_encounter_diagnose_update_args
			if update_data[:type_code] != @diagnose.type_code
				update_data[:rank] = ::Hospital::Diagnose.get_rank(params[:encounter_id], update_data[:type_code])
			end
	    if @diagnose.update_attributes(update_data)
	    	@diagnoses = ::Hospital::Diagnose.where(encounter_id: params[:encounter_id]).order(:type_code).order(:rank)
				all_ret = ::Hospital::Diagnose.to_master_and_slaver(@diagnoses)
	    	format.html { redirect_to @diagnose, notice: 'diagnose was successfully updated.'}
	    	format.json { render json: {flag: true, info:"", master: all_ret[:master], data: @diagnose.to_web_front} }
	    	# format.json { render json: {flag: true, info:"", master: all_ret[:master], data: all_ret[:master] + all_ret[:slaver]} }
	    else
	    	format.html { render action: "edit" }
	    	format.json { render json: {flag: false, info: "#{@diagnose.errors.messages}"} }
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
			render json: {flag: false, info: "#{@diagnose.errors.messages}", data: @diagnose.to_web_front}
		end
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

    # 获取当前就诊信息
    def set_cur_encounter
      @cur_encounter =  ::Hospital::Encounter.find(params[:encounter_id]) rescue nil
      return render json:{flag:false, info: "无效就诊id 请刷新重试 或联系管理员"} if @cur_encounter.nil?
      return render json:{flag:false, info: "非本人创建数据 不可操作"} if @cur_encounter.author_id != current_user.id
    end

		# Use callbacks to share common setup or constraints between actions.
	  def set_diagnose
	    @diagnose = Hospital::Diagnose.find(params[:id]) rescue nil
	    return render json:{flag: false, info:"无效诊断id"} if @diagnose.nil?
      return render json:{flag: false, info:"不能操作非本机构数据"} if @diagnose.org_id != @cur_org.id
	  end

	  def change?
      flag = @diagnose.doctor_id == current_user.id ? true : false
      return render json:{flag: false, info: "不能操作非本人创建的数据"} if !flag
    end

	  def can_sort?
	  	@tag = ::Hospital::Diagnose.find(params[:tag_id])
	  	@exchange = ::Hospital::Diagnose.find(params[:exchange_id])
	  	if @tag.org_id != @cur_org.id || @exchange.org_id != @cur_org.id
	  		return render json:{flag: false, info: "不能操作非本机构数据"}
	  	end
	  	if @tag.doctor_id != current_user.id || @exchange.doctor_id != current_user.id
	  		return render json:{flag: false, info: "不能操作非本人创建数据"}
	  	end
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
				doctor_id: current_user.id,
				type_code: args[:type][:code],
				type_display: args[:type][:display],
				note: args[:note],
				fall_ill_at: args[:fall_ill_at],
				org_id: @cur_org.id
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
				doctor_id: current_user.id,
				type_code: args[:type][:code],
				type_display: args[:type][:display],
				note: args[:note],
				status: args[:status],
				fall_ill_at: args[:fall_ill_at],
				org_id: @cur_org.id
	  	}
	  	return ret
	  end
end
# encoding: utf-8
class Healthcloud::PartnerAccountsController < ApplicationController
	#====2018-4-28====hujun=====================
	skip_before_action :verify_authenticity_token, :only => [:set_ws_sys, :update_ws_sys]

	before_action :ws_sys,only:[:update_ws_sys]
	before_action :ajax_access
	rescue_from RuntimeError do |exception|
		respond_to do |f|
			f.html {render xml:{flag:false,reason:exception.class.to_s,info:exception.message}}
			f.json {render json:{flag:false,reason:exception.class.to_s,info:exception.message}}
		end
	end
	layout false

	def pictures
		raise "图片名不能为空" unless params[:name].present?
		f=File.open("/app/healthcloud/lin/#{params[:name]}") rescue (raise "图片不存在")
		send_file(f)
		# /healthcloud/partner_accounts/pictures?name=ws_hello20170918173552.jpg
		f.close
	end

	def index
		render json:{flag:true,count:1,partner_accounts:[{strPrgID:'ad',strPrgPws:'ad',company:'tl'}]}
	end

	#创建一个系统权限用户
	def set_ws_sys
		# health=HealthCloud::WsSys.create(params[:account])
		# if health.valid?
		# 	render json:{flag:true,partner_account:health,info:"保存成功"}
		# else
		# 	render json:{flag:false,info:"保存失败,原因:#{health.errors.messages}"}
		# end
		#====2018-4-28====hujun=====================
		health = HealthCloud::WsSys.new(set_account)
		if health.save
			render json: { flag: true, partner_account: health,info: "保存成功"}
		else
			render json: {flag: false, info: "保存失败,原因:#{health.errors.fulle_messages.join(',')}"}
		end
	end

	#获取最新的数据
	def get_last_data
		hash_return,valname={},""
		hash_table={"ws_ring"=>HealthCloud::WsRing,
				"ws_heart_v2"=>HealthCloud::WsHeartVt,
				"ws_weight"=>HealthCloud::WsWeight,
				"ws_blood"=>HealthCloud::WsBlood,
				"ws_blood_sugar"=>HealthCloud::WsBloodSugar,
				"ws_ecg_heart"=>HealthCloud::WsEcgHeart,
		}
		hash_table.each do |key,val|
			case key
			when "ws_ring"
				valname=val.where("userid"=>current_user.id).order("recordTime").last 
			when "ws_heart_v2"
				valname=val.where("userid"=>current_user.id).order("strRecordDate").last
			when "ws_weight"
				valname=val.where("userid"=>current_user.id).order("datRecordTime").last
			when "ws_blood"
				valname=val.where("userid"=>current_user.id).order("datRecordTime").last
			when "ws_blood_sugar"
				valname=val.where("userid"=>current_user.id).order("datRecordTime").last
			when "ws_ecg_heart"
				valname=val.where("userid"=>current_user.id).order("datRecordTime").last
			end
			hash_return["#{key}"]=valname
		end
		render json:{flag:true,info:'获取成功',data:hash_return}
	end

	#删除一个系统权限用户
	def def_ws_sys
		# p '22222222222222222222'
		# p params[:_id].to_s
		health = HealthCloud::WsSys.find(params[:id])
		health.destroy
		render json:{flag:true,info:'删除成功'}
	end

	#修改一个系统权限用户
	def update_ws_sys
		if @health.update_attributes(set_account)
			render json:{flag:true,partner_account:@health,info:"保存成功"}
		else
			render json:{flag:false,info:"保存失败,原因:#{@health.errors.full_messages.join(',')}"}
		end
	end
	#查询所有表 尝试'user'
	def find_test
		table_n=params[:table_name]
		tableinfo=get_tableinfo
		table_name=tableinfo[table_n]
		if table_name
			if table_name=="User"
				@table_tables=eval(table_name).where("name like '%#{params[:search]}%' or login like '%#{params[:search]}%'").order("created_at desc").page(params[:page]).per(params[:per])
				ret = @table_tables
			elsif table_name=="HealthCloud::WsLog"
				@table_tables=eval(table_name).where("info like '%#{params[:search]}%' or method like '%#{params[:search]}%'").order("created_at desc").page(params[:page]).per(params[:per])
				ret = @table_tables
			else
				@table_tables=eval(table_name).all.order("created_at desc").page(params[:page]).per(params[:per])
				ret = @table_tables
			end
		end
		render json:{flag:true, count:@table_tables.count, data:ret}
	end
	#获取某个成员的数据
	def get_date_by_id
		#.where('ii.root'=>current_user.org_ii)
		table_n=params[:table_name]
		tableinfo=get_tableinfo
		table_name=tableinfo[table_n]
		s_time=params[:start_date].present? && params[:start_date] || Time.now.beginning_of_day
		e_time=params[:end_date].present? && params[:end_date] || Time.now.end_of_day
		if table_name
			if table_name=="User"
				render json:{flag:true, ws_user:eval(table_name).find(current_user.id)}
			else
				case table_name
				# when "HealthCloud::WsHeartVt"
				# 	@table_tables=eval(table_name).where("userid"=>current_user.id,:HRValue.ne=>"0",:strRecordDate.gte=>"#{s_time}",:strRecordDate.lte=>"#{e_time}").order("strRecordDate")
				when "HealthCloud::WsBlood","HealthCloud::WsWeight","HealthCloud::WsBloodSugar","HealthCloud::WsEcgHeart"
					# p '~~~~~~~~~~~~~~',table_name,s_time,e_time
					@table_tables=eval(table_name).where("userid"=>current_user.id).where("datRecordTime >= '#{s_time}' or datRecordTime <= '#{e_time}'").order("datRecordTime")
				# when "HealthCloud::WsRing"
				# 	@table_tables=eval(table_name).where("userid"=>current_user.id,:recordTime.gte=>"#{s_time}",:recordTime.lte=>"#{e_time}").order("recordTime")
				else
					@table_tables=eval(table_name).where("userid"=>current_user.id).order("created_at desc").page(params[:page]).per(params[:per])
				end
				render json:{flag:true, count:@table_tables.count, data:@table_tables}
			end
		else
			raise 'table_name error'
		end
	end

	def get_tableinfo
		tableinfo={"ws_sys"=>"HealthCloud::WsSys",
					"ws_user"=>"User",
					"ws_blood"=>"HealthCloud::WsBlood",
					"ws_weight"=>"HealthCloud::WsWeight",
					"ws_sport"=>"HealthCloud::WsSport",
					"ws_blood_sugar"=>"HealthCloud::WsBloodSugar",
					"ws_ring"=>"HealthCloud::WsRing",
					"ws_sleep"=>"HealthCloud::WsSleep",
					"ws_diet"=>"HealthCloud::WsDiet",
					"ws_member"=>"HealthCloud::WsMember",
					"ws_heart"=>"HealthCloud::WsHeart",
					"ws_question"=>"HealthCloud::WsQuestion",
					"ws_sleep_v2"=>"HealthCloud::WsSleepVt",
					"ws_heart_v2"=>"HealthCloud::WsHeartVt",
					"ws_ecg_breath"=>"HealthCloud::WsEcgBreath",
					"ws_ecg_heart"=>"HealthCloud::WsEcgHeart",
					"ws_log"=>"HealthCloud::WsLog"}
	end

	private
	def ws_sys
		id = params[:account].delete(:_id)['$oid']
		params[:account].delete(:created_at)
		params[:account].delete(:updated_at)
		@health = HealthCloud::WsSys.find(id)
	end

	#====2018-4-28====hujun=====================
	def set_account
		params.require(:account).permit(:company, :strPrgID, :strPrgPws)
	end

	def ajax_access
		response.headers['Access-Control-Allow-Origin'] = '*'
	end
end
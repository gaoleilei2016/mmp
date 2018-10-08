class Ims::ItemsController < ApplicationController
	def index
	end

	def get_items
    search = params[:search].to_s
    mode = Dict::Medication.where("ecode LIKE ? OR name LIKE ? OR common_name LIKE ? OR common_py LIKE ? OR common_wb LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
		lines = mode.order(created_at: :desc).page(params[:page]||1).per(params[:per]||25)#.map { |e| e.to_web_front  }
    # cur_author_patients_count =  Dict::Medication.count
    p cur_author_patients_count =  mode.count
		items = {
				#表格显示的内容
				title:[
          { label: '药品编码', prop: 'pt_code', width:"60"},
          { label: '易用码', prop: 'ecode', width:"60"},
          { label: '通用名称', prop: 'name', width:"120"},
          { label: '规格', prop: 'spec', width:"100"},
          { label: '剂型名称', prop: 'formul_name', width:"50"},
          { label: '基本单位', prop: 'base_unit', width:"40"},
          { label: '销售单位', prop: 'unit', width:"40"},
          { label: '销售价格', prop: 'price', width:"100"},
          { label: '厂家名称', prop: 'produce_name', width:"100"},
				],
				lines:lines}
		render json:{flag:true,info:"success",data:items, count: cur_author_patients_count}
	end

	def save_item
		para = params[:item]
		names = Dict::Medication.attribute_names
		# p names
		para.keep_if{|k,v| names.include?(k)}
		para.delete(:created_at)
		para.delete(:updated_at)
		serialno = para.delete(:serialno)


		begin
		runsql=ActiveRecord::Base.connection()
		if serialno&&serialno.present?
			str = ""
			para.each do |k,v|
				str += "#{k}='#{v}'," if v.present?
			end
			str = str.chop
			sql_update = "UPDATE dictmedicine SET #{str} WHERE serialno=#{serialno}"
			rest = runsql.update sql_update
			if rest
				render json:{flag:true,info:"更新成功"}
			else
				render json:{flag:false,info:"更新失败，请重试"}
			end
		else
			keys = para.keys.join(",")
			values = para.values.each
			str = ""
			para.each do |k,v|
				str += "'#{v}'," 
			end
			str = str.chop

			sql_create = "INSERT INTO dictmedicine ( #{keys} ) VALUES ( #{str} )"
			rest = runsql.insert sql_create
			if rest
				render json:{flag:true,info:"保存成功"}
			else
				render json:{flag:false,info:"保存失败，请重试"}
			end
		end

		rescue Exception => e
			print "laaaaaaaaaaaaaaaaaaaa 保存 出错: " + e.backtrace.join("\n")
			render json:{flag:false,info:"#{e.backtrace.join("\n")}"}
		end		
	end

	def change_status
		p params

		serialno = params[:line][:serialno]
		status = status_machine(params[:line][:status])
		if serialno
			
			runsql=ActiveRecord::Base.connection()
			sql_update = "UPDATE dictmedicine SET status='#{status}' WHERE serialno=#{serialno}"
			rest = runsql.update sql_update
			p "+++++++++++++++  #{rest}  ++++++++++++++++++++"
			if rest
				render json:{flag:true,info:"药品更改成功",status:status}
			else
				render json:{flag:false,info:"药品更改失败"}
			end
		else
			render json:{flag:false,info:"没有药品ID，不能更改药品"}
		end
	end

	def delete_item
		serialno = params[:line][:serialno]
		status = status_machine(params[:line][:status])
		if serialno
			runsql=ActiveRecord::Base.connection()
			sql_delete = "DELETE FROM dictmedicine WHERE serialno=#{serialno}"
			rest = runsql.delete sql_delete
			p "+++++++++++++++  #{rest}  ++++++++++++++++++++"
			if rest
				render json:{flag:true,info:"药品删除成功",status:status}
			else
				render json:{flag:false,info:"药品删除失败"}
			end
		else
			render json:{flag:false,info:"没有药品ID，不能删除药品"}
		end
	end

	private
		def status_machine status
			case status
			when "A" # 可用的药品
				"S"
			when "S" # 停用的药品
				"A"
			else
				"A"
			end
		end
end

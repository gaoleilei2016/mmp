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
			p sql_update
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
			print "laaaaaaaaaaaaaaaaaaaa 过账方法 出错: " + e.backtrace.join("\n")
			render json:{flag:false,info:"#{e.backtrace.join("\n")}"}
		end		
	end
end

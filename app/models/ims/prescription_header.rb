#encoding:utf-8
# => 药店-处方
class Ims::PrescriptionHeader < ApplicationRecord
	has_many :details, class_name: '::Ims::PrescriptionDetail', foreign_key: 'header_id'

	class << self

		# 处方单保存 
		def save_prescription args = {}
			return {flag:false,info:"处方信息为空。发药失败！"} if args[:prescriptions].blank?
			return {flag:false,info:"没有获取到发药用户信息。"} if args[:current_user].blank?
			current_user = args[:current_user]
			order = args[:order]
			prescription_headers = []
			# ::ActiveRecord::Base.transaction do
			# ::ActiveRecord::Base.transaction(:requires_new => true) do
				args[:prescriptions].each do |k,prescription|
					header = prescription_data prescription,current_user,order
					next if header.blank?
					(prescription_headers << ::Ims::PrescriptionHeader.create!(header) ) unless ::Ims::PrescriptionHeader.where(prescription_no:prescription[:prescription_no]).count>0
				end
				# raise ActiveRecord::Rollback
			# end
			prescription_headers.count==args[:prescriptions].count ? {flag:true,info:"处方保存成功！"} : {flag:false,info:"处方保存失败。"}
		end

		def prescription_data prescription= {},current_user,order
			begin
				details = (prescription[:orders]||[]).map{|detail| 
					{
						:serialno=> detail[:serialno],
						:title=> detail[:title],
						:specification=> detail[:specification],
						:single_qty_value=> detail[:single_qty][:value],
						:single_qty_unit=> detail[:single_qty][:unit],
						:dose_value=> detail[:dose][:value],
						:dose_unit=> detail[:dose][:unit],
						:route_value=> detail[:route][:value],
						:route_unit=> detail[:route][:unit],
						:frequency_code=> detail[:frequency][:code],
						:frequency_display=> detail[:frequency][:display],
						:course_of_treatment_value=> detail[:course_of_treatment][:value],
						:course_of_treatment_unit=> detail[:course_of_treatment][:unit],
						:formul_code=> detail[:formul][:code],
						:formul_display=> detail[:formul][:display],
						:qty=> detail[:total_quantity],
						:send_qty=> detail[:total_quantity],
						:return_qty=> 0,
						:unit=> detail[:unit],
						:price=> (detail[:price].to_f/detail[:total_quantity].to_f).round(4),
						:amount=> detail[:price],
						:note=> detail[:note],
						:status=> '4',
						:order_type=> detail[:order_type],
						:encounter_id=> detail[:encounter_id],
						:author_id=> detail[:author][:id],
						:author_name=> detail[:author][:name],
						:factory_name=> detail[:factory_name],
						:base_unit=> detail[:base_unit],
						:mul=> detail[:mul],
						:purch_mul=> (Dict::Medication.find detail[:serialno]).try(:purch_mul),
						:measure_val=> detail[:measure_val],
						:measure_unit=> detail[:measure_unit],
						:type_type=> detail[:type_type],
						:hospital_prescription_order_id=> detail[:id],
					}
				}
				return {} if details.blank?
				details_1 = Ims::PrescriptionDetail.create(details)
				header = {
					:prescription_no=>prescription[:prescription_no] ,
					:note=>prescription[:note] ,
					:type_code=>prescription[:type][:code] ,
					:type_name=>prescription[:type][:display] ,
					:confidentiality_code=>prescription[:confidentiality][:code] ,
					:confidentiality_name=>prescription[:confidentiality][:display] ,
					:name=>prescription[:name] ,
					:gender_code=>prescription[:gender][:code] ,
					:gender_name=>prescription[:gender][:display] ,
					:age=>prescription[:age] ,
					:birth_date=>prescription[:birth_date] ,
					:iden=>prescription[:iden] ,
					:occupation_code=>prescription[:occupation][:code] ,
					:occupation_name=>prescription[:occupation][:display] ,
					:phone=>prescription[:phone] ,
					:address=>prescription[:address] ,
					:org_id=>prescription[:org][:id] ,
					:org_display=>prescription[:org][:display] ,
					:patient_no=>prescription[:patient_no] ,
					:author_id=>prescription[:author][:id] ,
					:author_display=>prescription[:author][:display] ,
					:encounter_loc_id=>prescription[:encounter_loc][:id] ,
					:encounter_loc_display=>prescription[:encounter_loc][:display] ,
					:total_amount=>prescription[:price] ,
					:delivery_id=>current_user.try(:id) ,
					:delivery_name=>current_user.try(:name) ,
					:delivery_org_id=>current_user.try(:organization_id) ,
					:delivery_org_name=>current_user.try(:organization).try(:name) ,
					:delivery_at=>Time.new ,
					:drug_store_id=>(prescription[:drug_store_id]||order.try(:target_org_id)),
					:drug_store_name=>(prescription[:drug_store_name]||order.try(:target_org_name)) ,
					:effective_start=>prescription[:effective_start] ,
					:effective_end=>prescription[:effective_end] ,
					:diagnoses=>(prescription[:diagnoses]||[].map{|e| e.display}).join(',') ,
					:specialmark=>prescription[:specialmark] ,
					:status=>'4' ,
					:bill_id=>order.try(:id) ,
					:bill_code=>order.try(:order_code) ,
					:bill_at=>order.try(:created_at) ,
					:hospital_prescription_at=>prescription[:created_at] ,
					:hospital_prescription_id=>prescription[:id] ,
					:is_returned=>false ,
					:details=>details_1,
				}
				return header
			rescue Exception => e
				print e.message
      	print "======= prescription_data 出错: " + e.backtrace.join("\n")
				{}
			end
		end

	end

	# :prescription_no           # => 处方号
	# :note                      # => 处方备注
	# :type_code                 # => 处方类型code(如：普通、精一)
	# :type_name                 # => 处方类型名称
	# :confidentiality_code      # => 处方权限code
	# :confidentiality_name      # => 处方权限名称
	# :name                      # => 患者名称
	# :gender_code               # => 性别code
	# :gender_name               # => 性别
	# :age                       # => 年龄
	# :birth_date                # => 出生日期
	# :iden                      # => 身份证号
	# :occupation_code           # => 职业code
	# :occupation_name           # => 职业名称
	# :phone                     # => 电话号码
	# :address                   # => 地址
	# :org_id                    # => 医院机构
	# :org_display               # => 医院名称
	# :patient_no                # => 就诊号
	# :author_id                 # => 医生id
	# :author_display            # => 医生姓名
	# :encounter_loc_id          # => 就诊科室id
	# :encounter_loc_display     # => 就诊科室名称
	# :total_amount              # => 处方总金额
	# :orders                    # => 该处方对应的医嘱
	# :delivery_id               # => 发药人id
	# :delivery_name             # => 发药人name 
	# :delivery_org_id           # => 接收、发药、退药药房  
	# :delivery_org_name         # => 接收、发药、退药药房    
	# :delivery_at               # => 发药时间 
	# :return_id                 # => 退药人id 
	# :return_name               # => 退药名称 
	# :return_org_id             # => 退药药房  
	# :return_org_name           # => 退药药房    
	# :return_at                 # => 退药时间 
	# :drug_store_id             # => 药房id
	# :drug_store_name           # => 药房名称
	# :effective_start           # => 有效期开始
	# :effective_end             # => 有效期截止
	# :diagnoses                 # => 该处方对应的诊断
	# :specialmark               # => 特殊处方标记
	# :status                    # => 状态
	# :bill_id                   # => 订单id
	# :bill_at                   # => 订单生成时间(order的created_at)
	# :hospital_prescription_at  # => 开处方时间
	# :hospital_prescription_id  # => 关联医院处方id
	# :is_returned               # => 该单是否已退药
	# :reason                    # => 退药原因
end

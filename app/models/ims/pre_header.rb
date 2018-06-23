#encoding:utf-8
# => 药店-处方
class Ims::PreHeader < ApplicationRecord
	has_many :details, class_name: '::Ims::PreDetail', foreign_key: 'header_id'

	class << self

		# 处方单保存 
		def save_prescription args = {}
			return {flag:false,info:"处方信息为空。发药失败！"} if args[:prescriptions].blank?
			return {flag:false,info:"没有获取到发药用户信息。"} if args[:current_user].blank?
			current_user = args[:current_user]
			order = args[:order]
			prescription_headers = []
			args[:prescriptions].each do |k,prescription|
				header = prescription_data prescription,current_user,order
				next if header.blank?
				(prescription_headers << ::Ims::PreHeader.create!(header) ) unless ::Ims::PreHeader.where(prescription_no:prescription[:prescription_no]).count>0
			end
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
						:route_code=> detail[:route][:code],
						:route_display=> detail[:route][:display],
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
						:author_name=> detail[:author][:display],
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
				details_1 = Ims::PreDetail.create(details)
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
					:source_org_id=>prescription[:org][:id] ,
					:source_org_name=>prescription[:org][:display] ,
					:patient_no=>prescription[:patient_no] ,
					:author_id=>prescription[:author][:id] ,
					:author_name=>prescription[:author][:display] ,
					:encounter_loc_id=>prescription[:encounter_loc][:id] ,
					:encounter_loc_name=>prescription[:encounter_loc][:display] ,
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
					:diagnoses=>(prescription[:diagnoses]||[]).map{|s| s.display}.join(",") ,
					:specialmark=>prescription[:specialmark] ,
					:status=>'4' ,
					:order_id=>order.try(:id) ,
					:order_code=>order.try(:order_code) ,
					:order_at=>order.try(:created_at) ,
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

	# rails generate scaffold Ims::PreHeader 
 #  prescription_no:integer 
 #  note:string 
 #  type_code:string 
 #  type_name:string 
 #  confidentiality_code:string 
 #  confidentiality_name:string 
 #  name:string 
 #  gender_code:string 
 #  gender_name:string 
 #  age:string 
 #  birth_date:datetime 
 #  iden:string 
 #  occupation_code:string 
 #  occupation_name:string 
 #  phone:string 
 #  address:string 
 #  source_org_id:integer 
 #  source_org_name:string 
 #  patient_no:string 
 #  author_id:integer 
 #  author_name:string 
 #  auditor_id:integer
 #  auditor_name:string
 #  audit_at:datetime
 #  charger_id:integer
 #  charger_name:string
 #  charge_at:datetime
 #  encounter_loc_id:integer 
 #  encounter_loc_name:string 
 #  total_amount:float 
 #  delivery_id:integer 
 #  delivery_name:string 
 #  delivery_org_id:integer
 #  delivery_org_name:string
 #  delivery_at:datetime 
 #  return_id:integer 
 #  return_name:string 
 #  return_org_id:integer
 #  return_org_name:string
 #  return_at:datetime 
 #  drug_store_id:integer 
 #  drug_store_name:string 
 #  effective_start:datetime 
 #  effective_end:datetime 
 #  diagnoses:string 
 #  specialmark:string 
 #  status:string 
 #  order_id:integer 
 #  order_code:string 
 #  order_at:datetime 
 #  create_bill_opt_id:integer
 #  create_bill_opt_name:string
 #  hospital_prescription_at:datetime 
 #  hospital_prescription_id:integer 
 #  is_return:boolean
 #  ori_id:integer
 #  ori_code:string
 #  tookcode:string
 #  reason:string

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
	# :source_org_id             # => 医院机构
	# :source_org_name           # => 医院名称
	# :patient_no                # => 就诊号
	# :author_id                 # => 医生id 作者id
	# :author_name               # => 医生姓名 作者姓名   author_display
	# :encounter_loc_id          # => 就诊科室id
	# :encounter_loc_name        # => 就诊科室名称   encounter_loc_display
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
	# :bill_at                   # => 订单生成时间(order的created_at) 账单创建时间
	# :hospital_prescription_at  # => 开处方时间
	# :hospital_prescription_id  # => 关联医院处方id
	# :is_returned               # => 该单是否已退药
	# :reason                    # => 退药原因
	# :tookcode                  # => 取药码

	# :doctor_id                 # => 医生id
	# :auditor_id                # => 审核人id
	# :auditor_name              # => 审核人姓名 # auditor_display
	# :audit_at                  # => 审核时间
	# :abandonor_id              # => 废弃人
	# :abandonor_name            # => 废弃人姓名 # abandonor_display
	# :abandon_at                # => 废弃时间
	# :create_bill_opt_id        # => 账单创建人
	# :create_bill_opt_name      # => 账单创建姓名 # create_bill_opt_display
	# :create_bill_opt_id        # => 账单创建人
	# :create_bill_opt_id        # => 账单创建人
	# :charger_id                # => 收费人
	# :charger_name              # => 收费人姓名 # charger_display
	# :charge_at                 # => 收费时间
	# :return_charge_opt_id      # => 退费人
	# :return_charge_opt_name    # => 退费人名称 # return_charge_opt_display
	# :return_charge_at          # => 退费时间
	# :is_read                   # => 标记是否

end

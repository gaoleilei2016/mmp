#encoding: utf-8
# 西药处方
class ::Hospital::Prescription < ApplicationRecord
	has_many :orders, class_name: '::Hospital::Order', foreign_key: 'prescription_id'
	belongs_to :encounter, class_name: '::Hospital::Encounter', foreign_key: 'encounter_id'
	has_many :diagnoses, class_name: '::Hospital::Diagnose', foreign_key: 'prescription_id'
	belongs_to :organization, class_name: '::Admin::Organization', foreign_key: 'organization_id'
	belongs_to :doctor, class_name: '::User', foreign_key: 'doctor_id'
	# belongs_to :bill, class_name: '::'


	def link_diagnoses(args, cur_user)
		self.reload
		args.each_with_index do |fhir_coding_diagnose, i|
			::Hospital::Diagnose.create({
				rank: i+1,
				code: fhir_coding_diagnose[:code],
				display: fhir_coding_diagnose[:display],
				system: "ICD10",
				prescription: self,
				doctor: cur_user
			})
		end
	end

	def link_orders(cur_orders, cur_user)
		self.reload
		cur_orders.each do |_order|
			_order.status = "A"
			_order.prescription_id = self.id
			_order.save
		end
	end



	def to_web_front
		self.reload
		# 患者信息
		cur_encounter = self.encounter
		patient_info = {
			# 姓名
			name: cur_encounter.name,
			# 性别
			gender: {
			  code: cur_encounter.gender_code, 
			  display: cur_encounter.gender_display
			},
			# 年龄
			age: cur_encounter.age,
			# 出生日期
			birth_date: cur_encounter.birth_date,
			# 身份证号
			iden: cur_encounter.iden,
			# 职业
			occupation:{
			  code: cur_encounter.occupation_code,
			  display: cur_encounter.occupation_display
			},
			# 电话
			phone: cur_encounter.phone,
			# 地址
			address: cur_encounter.address,
		}
		# 机构信息
		cur_org = self.organization
		organization_info = {
			# 处方开单机构
			org:{
				id: cur_org.id,
				display: cur_org.name
			}
		}
		# 就诊信息
		cur_doctor = self.doctor
		encounter_info = {
			# 就诊号
			patient_no: cur_encounter.outpatient_no,
			# 就诊医生
			author: {
				id: cur_doctor.id,
				display: cur_doctor.name
			},
			# 就诊科室
			encounter_loc: {
				id: '',
				display: ''
			}
		}

		# 处方信息
		prescription_info = {
			# 处方id 
			id: self.id,
			# 处方号
			prescription_no: self.prescription_no || Time.now.to_i,
			# 处方状态
			status: self.status,
			# 处方备注
			note: self.note,
			# 处方类型 精一等
			type: {
				code: self.type_code,
				display: self.type_display
			},
			# 账单id
			bill_id: self.bill_id,
			# 处方权限
			confidentiality: {
				code: self.confidentiality_code,
				display: self.confidentiality_display
			},
			# 有效期开始
			effective_start: self.effective_start,
			# 有效期截止
			effective_end: self.effective_end,
			# 该处方对应的诊断
			diagnoses: self.diagnoses,
			# 该处方对应的医嘱
			orders: self.orders.map { |e| e.to_web_front  },
			price: self.orders.map{|e| e.price }.reduce(:+),
			specialmark: self.specialmark,
			created_at: self.created_at,
			updated_at: self.updated_at
		}
		ret = {}.merge(patient_info).merge(organization_info).merge(encounter_info).merge(prescription_info)
		return ret
	end

	def send_to_check
		self.reload
		# 审核成功 自动审核
		flag = true
		cur_encounter = self.encounter
		cur_org = self.organization
		cur_doctor = self.doctor
		price = self.orders.map{|e| e.price }.reduce(:+)
		total_fee = [price.to_s ,"元"].join(" ")
		#发送短信息
		# args = {type: :take_medic, name: '患者姓名', number:'处方单号', total_fee: '处方单总金额+单位',number1: '取药码', url: 'http连接', phone: '手机号码'}
		args = {type: :take_medic, name: cur_encounter.name, number: self.prescription_no || Time.now.to_i, total_fee: total_fee,number1: '1111', url: 'http连接', phone: cur_encounter.phone}
		p args
		Sms::Data.send_phone(args)
	end

	class<<self

	end

end


# organization_id:integer # => 机构id Admin::Organization 关联 字段
# status:string  # => 1-1 处方状态(N: '待审核',H: '审核失败',A: '待交费',O: '废弃'(处方删除),S: '过期',P: '待发药',E: '已发药',E: '已退药'的原处方只改发药状态,C: '已退药'新生成退药处方单,T: '已退费'(ET/PE),知道是待交费还是已发药的退费(或发票作废)) 
# note:string # => 备注信息
# code:string # => 处方类型  普通处方 精一  精二等  2.16.156.1.675425699.1.50
# bill_id:integer # => 关联字段
# confidentiality:string  # => 保密 {"code"=>"B", "display"=>"医院"}, {"code"=>"I", "display"=>"个人"}
# doctor_id:integer # => 医生
# encounter_id:integer # => 就诊信息
# effective_start:datetime # => 有效期开始
# effective_end:datetime # => 有效期结束
# # diagnoses: # => 关联
# # orders: # => 关联












# #处方信息
# field :ii,                   type: FHIR::InstanceIdentifier # =>  1-1 机构代码、处方号
# field :invoice_no,           type: String                   # => 发票号
# field :status,               type: String                   # => 1-1 处方状态(N: '待审核',H: '审核失败',A: '待交费',O: '废弃'(处方删除),S: '过期',P: '待发药',E: '已发药',E: '已退药'的原处方只改发药状态,C: '已退药'新生成退药处方单,T: '已退费'(ET/PE),知道是待交费还是已发药的退费(或发票作废))  
# field :charge_status,        type: String                   # => 收费状态(N:待交费，A:已缴费，E:已退费(或已作废))
# field :delivery_status,      type: String                   # => 发药状态(A:待发药，E:已发药，C:已退药，T:已停止)
# field :messages,             type: String                   # =>  0-* 系统信息
# field :note,                 type: String                   # =>  0-1 备注信息
# field :repeat_number,        type: Integer                  # =>  中药处方&1-1   中药处方副数
# field :code,                 type: FHIR::Coding             # => 处方类型 1-1 code、system 必填    处方签类型代码表[2.16.156.1.675425699.1.50]
# field :reason_code,          type: FHIR::Coding             # => 1-1 中西药处方类型  西药{code:"0",display:"西药"}  中草药{code:"1", display:"中草药"}   
# field :total_amount,         type: FHIR::Money              # => 1-1 总金额  含中药副数
# field :bill,                 type: FHIR::Reference          # => 1-1 账单id  Act::PatientBill
# field :source,               type: FHIR::Coding             # => 1-1处方来源
# field :data_enterer,         type: FHIR::Reference          # => 处方录入者
# # field :created_at                                         

# field :confidentiality,      type: FHIR::Coding             # => 保密
# #开单   
# field :author,               type: FHIR::Reference          # => 开方医生角色
# field :biller_loc,           type: FHIR::Reference          # => 开单科室
# field :billing_at,           type: DateTime                 # => 开单时间
# #审核   
# field :audit_loc,            type: FHIR::Reference          # => 审核药房
# field :auditor,              type: FHIR::Reference          # => 审核药人
# field :audit_at,             type: DateTime                 # => 审核药时间
# #配药   
# field :dispense_loc,         type: FHIR::Reference          # => 配药房
# field :dispenser,            type: FHIR::Reference          # => 配药人
# field :dispense_at,          type: DateTime                 # => 配药时间
# #核对   
# field :check_loc,            type: FHIR::Reference          # => 核对房
# field :checker,              type: FHIR::Reference          # => 核对人
# field :check_at,             type: DateTime                 # => 核对时间
# #发药   
# field :delivery_loc,         type: FHIR::Reference          # => 发药房
# field :delivery,             type: FHIR::Reference          # => 发药人
# field :delivery_at,          type: DateTime                 # => 发药时间
# field :delivery_win,         type: String                   # => 发药窗口  
# #收费人    
# field :charger,              type: FHIR::Reference          # => 收费人
# field :charge_loc,           type: FHIR::Reference          # => 收费科室
# field :charge_at,            type: DateTime                 # => 收费时间
# #退药申请人
# field :return_drug_reqer,    type: FHIR::Reference          # => 退药申请人
# field :return_drug_req_loc,  type: FHIR::Reference          # => 退药申请人科室
# field :return_drug_req_at,   type: DateTime                 # => 退药申请人的时间
# field :return_drug_pre_ids,  type: String,default:[]        # => 退药关联的处方ids
# #退药执行人
# field :return_drug_opter,    type: FHIR::Reference          # => 退药执行人
# field :return_drug_opt_loc,  type: FHIR::Reference          # => 退药执行人科室
# field :return_drug_opt_at,   type: DateTime                 # => 退药执行时间

# field :encounter,            type: FHIR::Reference          # => 就诊信息
# field :patient,              type: FHIR::Reference          # => 病人信息 身份证号特殊处方需要
# #患者信息就地保存
# field :encounter_ii,         type: FHIR::InstanceIdentifier # => 就诊号/住院号
# field :patient_iden,         type: String                   # => 身份识别号
# field :patient_name,         type: String                   # => 姓名
# field :patient_gender,       type: FHIR::Coding             # => 病人性别
# field :patient_age,          type: String                   # => 就诊年龄
# field :patient_addr,         type: String                   # => 病人地址
# field :patient_nature,       type: FHIR::Coding             # => 病人性质(对应门诊就诊费用类型) 编码表[2.16.156.1.675425699.1.202]
# field :patient_reg_type,     type: FHIR::Coding             # => 门诊挂号类型  编码表[2.16.156.1.675425699.1.32]
# field :patient_loc,          type: FHIR::Reference          # => 病人科室
# field :patient_area,         type: FHIR::Reference          # => 病人病区
# field :patient_bed_no,       type: FHIR::Reference          # => 病人床位号
# field :diagnoses,            type: FHIR::Coding,default:[]  # => 0-* 诊断
# field :label,                type: Array                    # => 0-1 病种标记  是否是特殊病  现在rails版本不能做位操作 
# field :label_mark,           type: String                   # => 0-1 是否是特殊门诊  字段来源于门诊 暂时只用于门诊
# field :qr_code,              type: String                   # => 支付二维码
# field :app_type,             type: String                   # => 支付商

# # field :label,                type: FHIR::Label            # => 0-* 病种标记  是否是特殊病
# # 是否特殊病  医保类型 是否打印 
# #明细 在有医嘱的情况下   药物列表（处方明细）的大部分数据来自医嘱 小部分来自ERP系统
# field :details,              type: FHIR::Prescription::Detail,default:[] # => 0-* 药物列表  处方明细
# field :orders,               type: FHIR::Reference,default:[]           # => 医嘱
# #操作记录
# field :event_histories,      type: FHIR::Reference,default:[]           # => 操作记录        
# field :effective_time,       type: FHIR::Period             # => 有效期
# field :search,               type: String
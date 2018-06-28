#encoding: utf-8
# 西药处方
class ::Hospital::Prescription < ApplicationRecord
	has_many :orders, class_name: '::Hospital::Order', foreign_key: 'prescription_id'
	belongs_to :encounter, class_name: '::Hospital::Encounter', foreign_key: 'encounter_id'
	has_many :diagnoses, class_name: '::Hospital::Diagnose', foreign_key: 'prescription_id'
	belongs_to :organization, class_name: '::Admin::Organization', foreign_key: 'organization_id' #处方所属机构
	belongs_to :doctor, class_name: '::User', foreign_key: 'doctor_id'
	belongs_to :drug_store, class_name: '::Admin::Organization', foreign_key: 'drug_store_id', optional: true
	belongs_to :bill, class_name: '::Orders::Order', foreign_key: 'bill_id', optional: true



	def initialize args = {}
		super args
		self.status = 0
	end


	###=== 处方状态流转  ===###
	# 创建后默认是 0: 未审核状态
	#每一个参数都是必传参数
	# {
	# 	# 审核人
	# 	auditor: {
	# 		id: User.id,
	# 		display: User.name
	# 	},
	# 	# 审核时间
	# 	audit_at: Time
	# }
	def audit!(args, cur_user)
		args.deep_symbolize_keys!
		if status == 0 # 未审核
				self.auditor_id = args[:auditor][:id] 
				self.auditor_display = args[:auditor][:display]
				self.audit_at = args[:audit_at]
				self.status = 1
			self.orders.update_all(status: 1) if self.save!
		else
			false
		end
	end

	# 处方废弃
	# {
	# 	# 废弃人
	# 	abandonor: {
	# 		id: User.id,
	# 		display: User.name
	# 	},
	# 	# 废弃时间
	# 	abandon_at: Time
	# }
	def abandon(args, cur_user)
		args.deep_symbolize_keys!
		if status == 1 # 已审核的处方可以废弃
				self.abandonor_id = args[:abandonor][:id] 
				self.abandonor_display = args[:abandonor][:display]
				self.abandon_at = args[:abandon_at]
				self.status = 7
			self.orders.update_all(status: 7) if self.save
		else
			false
		end
	end

	# 处方废弃
	# {
	# 	# 废弃人
	# 	abandonor: {
	# 		id: User.id,
	# 		display: User.name
	# 	},
	# 	# 废弃时间
	# 	abandon_at: Time
	# }
	def not_audit_to_abandon(args, cur_user)
		args.deep_symbolize_keys!
		if status == 1 # 已审核的处方可以废弃
				self.abandonor_id = args[:abandonor][:id] 
				self.abandonor_display = args[:abandonor][:display]
				self.abandon_at = args[:abandon_at]
				self.status = 7
			self.orders.update_all(status: 7) if self.save
		else
			false
		end
	end

	# 已审核处方  生成订单之后待收费
	# {
	# 	# 创建订单人
	# 	create_bill_opt: {
	# 		id: User.id,
	# 		display: User.name
	# 	},
	# 	# 订单创建时间
	# 	bill_at: Time
	#   bill_id: 
	# }
	# def wait_charge(args, cur_user)
	def commit_bill(args, cur_user)
		args.deep_symbolize_keys!
		if status == 1 # 已审核的处方可以变为待收费
			# self.status = 2
			self.status = 10
			self.create_bill_opt_id = args[:create_bill_opt][:id]
			self.create_bill_opt_display = args[:create_bill_opt][:display]
			self.bill_at = args[:bill_at]
			self.bill_id = args[:bill_id]
			self.orders.update_all(status: 10) if  self.save
		else
			false
		end
	end

	# 待收费转为已审核
	# def back_wait_charge(args, cur_user)
	#  {
	# 	args: {}
	# 	cur_user: User
	#  }
	def cancel_bill(args, cur_user)
		args.deep_symbolize_keys!
		if status == 10 # 已审核的处方可以变为待收费
			self.status = 1
			self.create_bill_opt_id = nil
			self.create_bill_opt_display = nil
			self.bill_at = nil
			self.bill_id = nil
			self.orders.update_all(status: 1) if  self.save
		else
			false
		end
	end

	# 已收费处方  账单收费后更新
	# {
	# 	# 创建订单人
	# 	charger: {
	# 		id: User.id,
	# 		display: User.name
	# 	},
	# 	# 订单创建时间
	# 	charge_at: Time
	# }
	def charged(args, cur_user)
		args.deep_symbolize_keys!
		if status == 2 # 已审核的处方可以变为待收费
			self.status = 3
			self.charger_id = args[:charger][:id]
			self.charger_display = args[:charger][:display]
			self.charge_at = args[:charge_at]
			self.orders.update_all(status: 3) if self.save
		else
			false
		end
	end

	# 已收费退费转为已审核
	# args = {
	# 	reason: ""
	# }
	def charged_back_to_audit(args, cur_user)
		args.deep_symbolize_keys!
		if status == 3 # 已审核的处方可以变为待收费
			self.status = 1
			self.charger_id = nil
			self.charger_display = nil
			self.charge_at = nil
			self.orders.update_all(status: 1) if self.save
		else
			false
		end
	end


	# 已收费后可以退费
	# {
	# 	# 退费人
	# 	return_charge_opt: {
	# 		id: User.id,
	# 		display: User.name
	# 	},
	# 	# 退费时间
	# 	return_charge_at: Time
	# }
	def return_charge(args, cur_user)
		args.deep_symbolize_keys!
		if status == 3 # 已审核的处方可以变为待收费
			self.status = 9
			self.return_charge_opt_id = args[:return_charge_opt][:id]
			self.return_charge_opt_display = args[:return_charge_opt][:display]
			self.return_charge_at = args[:return_charge_at]
			self.orders.update_all(status: 9) if self.save
		else
			false
		end
	end

	# 发药
	# {
	# 	# 发药人
	# 	delivery: {
	# 		id: User.id,
	# 		display: User.name
	# 	},
	# 	# 发药时间
	# 	delivery_at: Time
	# }
	def send_drug(args, cur_user)
		args.deep_symbolize_keys!
		if status == 3
			self.status = 4
			self.delivery_id = args[:delivery][:id] 
			self.delivery_display = args[:delivery][:display]
			self.delivery_at = args[:delivery_at]
			self.orders.update_all(status: 4) if  self.save
		else
			false
		end
	end

	# 退药
	# {
	# 	# 退药人
	# 	return_drug_opter: {
	# 		id: User.id,
	# 		display: User.name
	# 	},
	#   return_drug_store_id:
	# 	# 退药时间
	# 	return_drug_opt_at: Time
	# }
	def return_drug(args, cur_user)
		args.deep_symbolize_keys!
		if status == 4
			self.status = 8
			return_drug_opter_id = args[:return_drug_opter][:id]
			return_drug_opter_display = args[:return_drug_opter][:display]
			return_drug_store_id = args[:return_drug_store_id]
			return_drug_opt_at = args[:return_drug_opt_at]
			self.orders.update_all(status: 8) if  self.save
		else
			false
		end
	end

	###=== 处方状态流转  ===###

	def link_diagnoses!(args, cur_user)
		args.each_with_index do |fhir_coding_diagnose, i|
			cur_diagnose = ::Hospital::Diagnose.new({
				rank: i+1,
				code: fhir_coding_diagnose[:code],
				display: fhir_coding_diagnose[:display],
				system: "ICD10",
				prescription: self,
				doctor: cur_user,
				org_id: cur_user.organization&.id
			})
			cur_diagnose.save!
		end
	end

	def link_orders!(cur_orders, cur_user)
		self.reload
		cur_orders.each_with_index do |_order, i|
			_order.status = 0
			_order.rank_in_prescription = i
			_order.prescription_id = self.id
			_order.save!
		end
	end


	# 这个方法是公共的接口方法  不能随意更改   字段可以增加  但是不能修改和删除
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
		cur_doctor = self.doctor # User
		encounter_info = {
			# 就诊号
			patient_no: cur_encounter.patient_no,
			# 就诊医生
			author: {
				id: cur_doctor.id,
				display: cur_doctor.name
			},
			# 就诊科室
			encounter_loc: {
				id: cur_encounter.encounter_loc_id,
				display: cur_encounter.encounter_loc_display
			}
		}
		# 药房信息
		drug_store_info = {
			drug_store: {
				id: self.drug_store&.id,
				display: self.drug_store&.name
			}
		}

		# 处方信息
		prescription_info = {
			# 处方id 
			id: self.id,
			# 处方号
			prescription_no: format("%010d",self.id),
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
			bill_status: self.bill&.status.to_s,
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
			orders: self.orders.order(:rank_in_prescription).map { |e| e.to_web_front  },
			price: self.orders.map{|e| e.price*e.total_quantity }.reduce(:+),
			specialmark: self.specialmark,
			created_at: self.created_at.getlocal.strftime("%Y-%m-%d %H:%M:%S"),
			updated_at: self.updated_at.getlocal.strftime("%Y-%m-%d %H:%M:%S"),
			is_read: self.is_read,
			auditor:{
				id: self.auditor_id,
				display: self.auditor_display
			},
			delivery:{
				id: self.delivery_id,
				display: self.delivery_display
			}

		}
		ret = {}.merge(patient_info).merge(organization_info).merge(encounter_info).merge(drug_store_info).merge(prescription_info)
		return ret
	end

	def set_tookcode!
		self.tookcode = format("%06d", self.id)
		self.save!
	end

	def send_to_check
		self.reload
		# 审核成功 自动审核
		flag = true
		cur_encounter = self.encounter
		cur_org = self.organization
		cur_doctor = self.doctor
		price = self.orders.map{|e| e.price*e.total_quantity }.reduce(:+)
		total_fee = price.round(2)
		url = "http://huaxi.tenmind.com/interfaces/gzh"
		#发送短信息
		# args = {type: :take_medic, name: '患者姓名', number:'处方单号', total_fee: '处方单总金额+单位',number1: '取药码', url: 'http连接', phone: '手机号码'}
		args = {type: :take_medic, name: cur_encounter.name, number: format("%010d",self.id), total_fee: total_fee,number1: self.tookcode, url: url, phone: cur_encounter.phone}
		Sms::Data.send_phone(args)
	end

	class<<self
		def overtime(prescription_ids)
		  ::Hospital::Prescription.find(prescription_ids).update_all(is_overtime: true)
		end

		def set_overtime_schedule(prescription_ids)

		end

	end
end
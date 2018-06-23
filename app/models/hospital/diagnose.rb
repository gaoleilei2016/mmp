class ::Hospital::Diagnose < ApplicationRecord

	# 诊断数据分两种   就诊诊断  处方诊断
	#验证分交叉数据验证和非交叉数据验证

	# 交叉数据验证
	# 诊断名称一定要存在 
	validates :display, :org_id, :doctor_id, presence: {message: "不能为空"}

	# 非交叉数据验证
	validates :status, presence: {message: "不能为空"}, if: -> { encounter_id.present? }


	belongs_to :doctor, class_name: '::User', foreign_key: 'doctor_id', optional: true
	belongs_to :encounter, class_name: '::Hospital::Encounter', foreign_key: 'encounter_id', optional: true
	belongs_to :prescription, class_name: '::Hospital::Prescription', foreign_key: 'prescription_id', optional: true
	belongs_to :organization, class_name: '::Admin::Organization', foreign_key: 'org_id', optional: true



	def initialize args = {}
		super args
		self.status = "A"
	end

	# 设置排序字段
	def set_rank
		self.rank = (::Hospital::Diagnose.where(encounter_id: self.encounter_id, type_code: self.type_code).order(rank: :desc).first.rank rescue 0) + 1
	end

	def to_web_front
		ret = {
			id: self.id,
			code: self.code,
			display: self.display,
			system: self.system,
			encounter_id: self.encounter_id,
			doctor:{
				id: self.doctor_id,
				display: self.doctor.name
			},
			type:{
				code: self.type_code,
				display: self.type_display
			},
			rank: self.rank,
			status: self.status,
			note: self.note,
			fall_ill_at: self.fall_ill_at,
			org_id: self.org_id,
			created_at: self.created_at,
			updated_at: self.updated_at
		}
	end

		class<<self
			# 主要诊断删除后更新  这个方法由更新就诊信息时区调用
			def batch_update(args, cur_encounter, cur_user)
				cur_diagnoses = Hospital::Diagnose.where(encounter_id: cur_encounter.id.to_s, type_code: 0).delete_all
				args.each_with_index do |fhir_coding_diagnose, i|
					::Hospital::Diagnose.create({
						rank: i+1,
						code: fhir_coding_diagnose[:code],
						display: fhir_coding_diagnose[:display],
						system: "ICD10",
						type_code: 0,
						type_display: "主诊断",
						encounter: cur_encounter,
						doctor: cur_user,
						org_id: cur_user.organization&.id,
						fall_ill_at: Time.now
					})
				end
			end

			# 交换两个诊断的顺序
			# tag_id 是被操作   exchange_id 是被更换的 都是互换顺序
			def swap(tag_id, exchange_id)
				cur_diagnoses = ::Hospital::Diagnose.find([tag_id, exchange_id])
				return {flag: false, info: "不同诊断类型不能交换顺序"} if cur_diagnoses[0].type_code != cur_diagnoses[1].type_code
				cur_diagnoses[0].rank, cur_diagnoses[1].rank = cur_diagnoses[1].rank, cur_diagnoses[0].rank
				return {flag: true, info: "success"}
			end

			def to_master_and_slaver(cur_diagnoses)
				master, slaver = [], []
				cur_diagnoses.each do |_diagnose|
					if _diagnose.type_code == 0
						master << _diagnose.to_web_front
					else
						slaver << _diagnose.to_web_front
					end
				end
				return {master: master, slaver: slaver}
			end
	end
end

class Hospital::Encounter < ApplicationRecord

	has_many :diagnoses, class_name: '::Hospital::Diagnose', foreign_key: 'encounter_id'
	belongs_to :person, class_name: '::Person', foreign_key: 'person_id', optional: true
	belongs_to :drugstore_location, class_name: '::Admin::Organization', foreign_key: 'drugstore_location_id', optional: true
	has_many :orders, class_name: '::Hospital::Order', foreign_key: 'encounter_id'
	has_many :prescriptions, class_name: '::Hospital::Prescription', foreign_key: 'encounter_id'

	#1:  如果有person_id就直接取到person
	#2:  如果没有就根据  身份证号、姓名、性别、联合查询  查询到的第一个人就当做是同一个人  然后建立关联   以后为了更严谨  需要加入更多的参数判别是不是同一人
	def get_person
	  return self.person if self.person.present?
	  cur_person = ::Person.where(name: self.name.strip, phone: self.phone.strip).first
	  if cur_person.nil?
	  	# 没有查询到 创建一个实体Person
	  	person_args = self.format_person_args
	  	cur_person = ::Person.create(person_args)
	  else
	  	#  查询到了
	  end
	  # 建立关系然后返回
	  self.person_id = cur_person.id
	  self.save
	  self.reload
	  return cur_person
	end

	def to_web_front
		self.reload
		ret = {
			id: self.id,
			iden: self.iden,
			name: self.name,
			name_jp: self.name_jp,
			name_wb: self.name_wb,
			birth_date: self.birth_date,
			age: self.age,
			gender: {
			  code: self.gender_code, 
			  display: self.gender_display
			},
			occupation:{
			  code: self.occupation_code,
			  display: self.occupation_display
			},
			phone: self.phone,
			address: self.address,
			unit_name: self.unit_name,
			ua_address: self.ua_address,
			unit_phone: self.unit_phone,
			contact_name: self.contact_name,
			contact_phone: self.contact_phone,
			hospital_oid: self.hospital_oid,
			hospital_name: self.hospital_name,
			patient_domain:{
			  code: self.patient_domain_code,
			  display: self.patient_domain_display
			},
			outpatient_no: self.outpatient_no,
			inpatient_no: self.inpatient_no,
			started_at: self.started_at,
			created_at: self.created_at,
			updated_at: self.updated_at,
			nation: {
			  code: self.nation_code,
			  display: self.nation_display
			},
			blood:{
			  code: self.blood_code,
			  display: self.blood_display
			},
			marriage:{
			  code: self.marriage_code,
			  display: self.marriage_display
			},
			height: self.height,
			weight: self.weight,
			diagnoses: self.diagnoses.map { |e| {code: e.code, display: e.display}  },
			allergens: self.person.irritabilities.map { |e| e.display  },
			person_id: self.person_id
		}
		# 当前就诊的取药点
		if self.drugstore_location.present?
			ret[:drugstore_location] = {
				id: self.drugstore_location.id,
				display: self.drugstore_location.name
			}
		else
			ret[:drugstore_location] = {}
		end
		# 
		return ret
	end


	def format_person_args
		self.reload
		ret = {
			iden: self.iden,
			name: self.name,
			birth_date: self.birth_date,
			age: self.age,
			gender_code: self.gender_code,
			gender_display: self.gender_display,
			nation_code: self.nation_code,
			nation_display: self.nation_display,
			marriage_code: self.marriage_code,
			marriage_display: self.marriage_display,
			occupation_code: self.occupation_code,
			occupation_display: self.occupation_display,
			phone: self.phone,
			unit_name: self.unit_name,
			ua_address: self.ua_address,
			unit_phone: self.unit_phone,
			contact_name: self.contact_name,
			contact_phone: self.contact_phone,
			blood_code: self.blood_code,
			blood_display: self.blood_display,
			height: self.height,
			weight: self.weight,
			#剩下字段和person不一致
			pa_address: self.address
		}
		# 删除值为空的字段 
		return ret.compact
	end

	def get_encounter_info_from_person
		self.reload
		cur_person = self.person
		encounter_info = {
			iden: cur_person.iden,
			name: cur_person.name,
			birth_date: cur_person.birth_date,
			age: cur_person.age,
			gender_code: cur_person.gender_code,
			gender_display: cur_person.gender_display,
			nation_code: cur_person.nation_code,
			nation_display: cur_person.nation_display,
			marriage_code: cur_person.marriage_code,
			marriage_display: cur_person.marriage_display,
			occupation_code: cur_person.occupation_code,
			occupation_display: cur_person.occupation_display,
			phone: cur_person.phone,
			unit_name: cur_person.unit_name,
			ua_address: cur_person.ua_address,
			unit_phone: cur_person.unit_phone,
			contact_name: cur_person.contact_name,
			contact_phone: cur_person.contact_phone,
			blood_code: cur_person.blood_code,
			blood_display: cur_person.blood_display,
			height: cur_person.height,
			weight: cur_person.weight,
			# 剩下字段和  encounter不一样
			address: cur_person.pa_address
		}
		return encounter_info.compact
	end

end

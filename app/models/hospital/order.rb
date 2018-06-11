class Hospital::Order < ApplicationRecord

	belongs_to :encounter, class_name: '::Hospital::Encounter', foreign_key: 'encounter_id', optional: true
	# has_one :dict_medication, class_name: '::Dict::Medication', foreign_key: 'order_id' 

	# order_type 医嘱类型 1 药品医嘱

	def dict_medication
		::Dict::Medication.find(self.serialno)
	end

	def to_web_front
		ret = {
			serialno: self.serialno,
			title: self.title,
			specification: self.specification,
			single_qty: {
				value: self.single_qty_value,
				unit: self.single_qty_unit
			},
			dose: {
				value:self.dose_value,
				unit: self.dose_unit
			},
			route:{
				code: self.route_code,
				display: self.route_display
			},
			frequency:{
				code: self.frequency_code,
			    display: self.frequency_display
			},
			course_of_treatment:{
				value: self.course_of_treatment_value,
				unit: self.course_of_treatment_unit
			},
			total_quantity: self.total_quantity,
			unit: self.unit,
			price: self.price,
			note: self.note,
			status: self.status,
			order_type: self.order_type,
			encounter_id: self.encounter_id	
		}
	end
end
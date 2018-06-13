class Hospital::Diagnose < ApplicationRecord

	belongs_to :doctor, class_name: '::User', foreign_key: 'doctor_id', optional: true
	belongs_to :encounter, class_name: '::Hospital::Encounter', foreign_key: 'encounter_id', optional: true
	belongs_to :prescription, class_name: '::Hospital::Prescription', foreign_key: 'prescription_id', optional: true


		class<<self
		def batch_update(args, cur_encounter, cur_user)
			cur_encounter.diagnoses.delete_all
			args.each_with_index do |fhir_coding_diagnose, i|
				::Hospital::Diagnose.create({
					rank: i+1,
					code: fhir_coding_diagnose[:code],
					display: fhir_coding_diagnose[:display],
					system: "ICD10",
					encounter: cur_encounter,
					doctor: cur_user
				})
			end
		end
	end
end

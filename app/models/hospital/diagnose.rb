class Hospital::Diagnose < ApplicationRecord

	belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
	belongs_to :encounter, class_name: 'Hospital::Encounter', foreign_key: 'encounter_id'
end

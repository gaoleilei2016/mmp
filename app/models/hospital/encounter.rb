class Hospital::Encounter < ApplicationRecord

	has_many :diagnoses, class_name: 'Hospital::Diagnose', foreign_key: 'encounter_id'
end

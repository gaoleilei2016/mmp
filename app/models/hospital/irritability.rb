class Hospital::Irritability < ApplicationRecord

	belongs_to :data_entry,  class_name: '::User', foreign_key: 'data_entry_id'
	belongs_to :person, class_name: '::Person', foreign_key: 'person_id'
end

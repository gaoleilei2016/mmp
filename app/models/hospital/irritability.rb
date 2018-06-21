class Hospital::Irritability < ApplicationRecord

	belongs_to :data_entry,  class_name: '::User', foreign_key: 'data_entry_id', optional: true
	belongs_to :person, class_name: '::Person', foreign_key: 'person_id', optional: true


	class<<self
		def batch_update(args, cur_person, cur_user)
			::Hospital::Irritability.where("person_id" => cur_person.id).delete_all
			args.each do |_name|
				t = ::Hospital::Irritability.create({
					display: _name,
					person: cur_person,
					data_entry: cur_user
				})
			end
		end
	end
end

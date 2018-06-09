class Person

	belongs_to :user,                   :class_name => '::User',                        :foreign_key => 'user_id'
	has_many :encounters,				:class_name => '::Hospital::Encounter',			:foreign_key => 'person_id'
end
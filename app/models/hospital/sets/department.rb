class ::Hospital::Sets::Department < ApplicationRecord

	belongs_to :organization,  class_name: "::Admin::Organization",       foreign_key: 'org_id', optional: true
	# belongs_to :doctors,  class_name: "::User",   foreign_key: 'department_id'

	class<<self
	end
end
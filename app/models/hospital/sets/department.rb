class ::Hospital::Sets::Department < ApplicationRecord


	# 每一个设置的科室必须存在机构
	belongs_to :organization,  class_name: "::Admin::Organization",       foreign_key: 'org_id'
end
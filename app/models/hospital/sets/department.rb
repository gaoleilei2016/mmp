class ::Hospital::Sets::Department < ApplicationRecord


	# 每一个设置的科室必须存在机构
	belongs_to :organization,  class_name: "::Admin::Organization",       foreign_key: 'org_id'
	
	# 获取当前User用户机构的所有用户列表 返回  id
	def self.get_cur_org_users(cur_user)
		ret = cur_user.organization.users.map { |_user| {id: _user.id, display: _user.name, login: _user.login} }
	end
end
class ::Hospital::Sets::Ini < ApplicationRecord

	belongs_to :organization, class_name: 'Admin::Organization', foreign_key: 'org_id'
	belongs_to :prescription_audit, class_name: '::User', foreign_key: 'prescription_audit_id'


	def to_web_front
		self.reload
		ret = {
			id: self.id,
			enable_print_pres: self.enable_print_pres,
			uoperator_id: self.uoperator_id,
			print_pres_html: self.print_pres_html,
			org_id: self.org_id,
			created_at: self.created_at,
			updated_at: self.updated_at,
			encounter_search_time: self.encounter_search_time,
			prescription_audit: {
				id: self.prescription_audit_id,
				display: self.prescription_audit&.name
			}
		}
		return ret
	end

	

	class<<self
		def get_org_ini(cur_user)
			cur_org = cur_user.organization
			cur_ini = ::Hospital::Sets::Ini.where("org_id" => cur_org.id).first
			cur_ini = ::Hospital::Sets::Ini.create("org_id" => cur_org.id) if cur_ini.nil?
			return cur_ini
		end

		# 获取当前User用户机构的所有用户列表 返回  id 登录名 名称
		def get_cur_org_users(cur_user)
			ret = (cur_user.organization&.users)||[].map { |_user| {id: _user.id, display: _user.name, login: _user.login} }
		end
	end
end



# rails g model Hospital::Sets::Ini enable_print_pres:boolean uoperator_id:integer print_pres_html:text org_id:integer
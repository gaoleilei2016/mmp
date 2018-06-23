class ::Hospital::Sets::Ini < ApplicationRecord

	validates :org_id, :uoperator_id, presence: {message: "不能为空"}
	# 关系不填写 optional: true 会影响验证的格式  所以加上了
	belongs_to :organization, class_name: 'Admin::Organization', foreign_key: 'org_id'
	belongs_to :prescription_audit, class_name: '::User', foreign_key: 'prescription_audit_id', optional: true  # 保存时不会查询数据库这条数据是否存在
	belongs_to :uoperator, class_name: '::User', foreign_key: 'uoperator_id'

	def to_web_front
		ret = {
			id: self.id,
			enable_print_pres: self.enable_print_pres,
			uoperator:{
				id: self.uoperator_id,
				display: self.uoperator.name
			},
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
		# 调用这个方法的人一定要有机构
		def get_org_ini(cur_user)
			cur_org = cur_user.organization
			cur_ini = ::Hospital::Sets::Ini.where(org_id: cur_org.id).first
			cur_ini = ::Hospital::Sets::Ini.create(org_id: cur_org.id, uoperator_id: cur_user.id) if cur_ini.nil?
			return cur_ini
		end

		# 获取当前User用户机构的所有用户列表 返回  id 登录名 名称
		def get_cur_org_users(cur_user)
			ret = (cur_user.organization&.users)||[].map { |_user| {id: _user.id, display: _user.name, login: _user.login} }
		end
	end
end
class ::Hospital::Sets::Ini < ApplicationRecord

	belongs_to :organization, class_name: 'Admin::Organization', foreign_key: 'org_id'


	def to_web_front
		ret = {
			id: self.id,
			enable_print_pres: self.enable_print_pres,
			uoperator_id: self.uoperator_id,
			print_pres_html: self.print_pres_html,
			org_id: self.org_id,
			created_at: self.created_at,
			updated_at: self.updated_at
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
	end
end



# rails g model Hospital::Sets::Ini enable_print_pres:boolean uoperator_id:integer print_pres_html:text org_id:integer
class ::Hospital::Sets::Ini < ApplicationRecord

	belongs_to :organization, class_name: 'Admin::Organization', foreign_key: 'org_id'


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
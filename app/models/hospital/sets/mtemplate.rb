class ::Hospital::Sets::MTemplate < ApplicationRecord



	class<<self
		# def get_org_ini(cur_user)
		# 	cur_org = cur_user.organization
		# 	cur_ini = ::Hospital::Sets::MTemplate.where("org_id" => cur_org.id).first
		# 	cur_ini = ::Hospital::Sets::MTemplate.create("org_id" => cur_org.id) if cur_ini.nil?
		# 	return cur_ini
		# end
	end
end



# rails g model Hospital::Sets::MTemplate enable_print_pres:boolean uoperator_id:integer print_pres_html:text org_id:integer
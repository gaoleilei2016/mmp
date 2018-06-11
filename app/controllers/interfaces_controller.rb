class InterfacesController < ApplicationController
	#############################
	############ zyz ############
	def get_pharmacy
		orgs = ::Admin::Organization.where(:type_code=>'2')
		render json:{rows:orgs,total:orgs.count}
	end
	############ zyz ############
	#############################
end

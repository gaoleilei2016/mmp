class Customer::ReportController < ApplicationController
	layout "customer"
	def index
		# p '~~~~~~~~',current_user.wowgo
		unless current_user.wowgo
			flash[:notice] = "体征信息未上传到社区，请重新填写您的体征信息"
			return redirect_to "/customer/home/user/edit?from=healthcloud"
		end
	end
	def qrcode
	end
end

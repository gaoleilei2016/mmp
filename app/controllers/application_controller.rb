class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action :configure_permitted_parameters, if: :devise_controller?
	# before_action :authenticate_user!
	rescue_from RuntimeError do |exception|
		respond_to do |html|
			html.html {render xml:{flag:false,reason:exception.class.to_s,info:exception.message}}
			html.json {render json:{flag:false,reason:exception.class.to_s,info:exception.message}}
		end
	end

	def index
	end
	def menus
		p '~~~~~~~~~ menus ',params[:path]
		case params[:path]
		when "admin/home"
			file_name = "admin"
		when "hospital/home"
			file_name = "hospital"
		when "ims/home"
			file_name = "ims"
		else
			raise "未处理的 controller_path : #{params[:path]} => ApplicationController#templates"
		end
		yml = YAML.load_file(File.join(Rails.root,"config/setup/menus/#{file_name}.yml"))
		render json:{menus:yml}
	end
	def templates
		p '~~~~~~~~~ templates ',params[:path]
		case params[:path]
		when "admin/home"
			dir_name = "/admin/home/templates"
		when "hospital/home"
			dir_name = "/hospital/home/templates"
		when "ims/home"
			dir_name = "/ims/home/templates"
		else
			raise "未处理的 controller_path : #{params[:path]} => ApplicationController#templates"
		end
		render "#{dir_name}/_#{params[:template_name]}.html.erb",layout:false
	end

	protected
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
	end
end

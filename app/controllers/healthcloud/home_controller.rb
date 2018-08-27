# encoding: utf-8
class Healthcloud::HomeController < ApplicationController
	layout false
	def index
	end
	def templates
		render "/healthcloud/home/templates/_#{params[:template_name]}.html.erb",layout:false
	end
end
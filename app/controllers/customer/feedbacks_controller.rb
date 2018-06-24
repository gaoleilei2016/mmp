class Customer::FeedbacksController < ApplicationController
	layout "customer"
	def index
	end
	def create
		p '~~~~~~~~~~~~~',params
	end
end

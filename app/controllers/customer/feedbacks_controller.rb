class Customer::FeedbacksController < ApplicationController
	layout "customer"
	def index
		feedbacks = ::Customer::Feedback.where(user_id:current_user.id).order("created_at desc").page(params[:page]).per(params[:per])
		render json:{flag:true,rows:feedbacks,total:feedbacks.total_count}
	end
	def create
		# p '~~~~~~~~~~~~~',params
		feed = ::Customer::Feedback.create({
			user_id:current_user.id,
			content:params[:feedback][:content],
			contact:params[:feedback][:contact],
			score:params[:feedback][:score],
		})
		if feed.valid?
			flash[:notice] = "保存成功"
			redirect_to '/customer/home/feedbacks'
		else
			flash[:notice] = "保存失败"
			redirect_to '/customer/home'
		end
	end
end

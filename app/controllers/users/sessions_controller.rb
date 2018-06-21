# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout "users"
  skip_before_action :verify_authenticity_token
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    flash[:login] = params[:login] if params[:login].present?
    if session[:openid]
      u = User.where(openid:session[:openid]).first
      if u
        sign_in(u)
        return redirect_to "/"
      else
        return redirect_to "/users/sign_up?login=#{params[:login]}" 
      end
    end
    str = request.user_agent
    if str.include?('Mobile')
      render "/devise/sessions/new2.html.erb",layout:"customer"
      # if params[:type]=="use_psw"
      # else
      #   redirect_to "/users/sign_up"
      # end
    else
      super
    end
  end

  # POST /resource/sign_in
  def create
    if current_user
      if current_user.login=="admin"
        path = "/admin/home"
      else
        case current_user.type_code
        when "1"
          path = "/hospital/home"
        when "2"
          path = "/ims/home"
        else
          path = "/"
        end
      end
      return redirect_to path
    else
      flash[:login] = params[:user][:login] rescue nil
      super
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end

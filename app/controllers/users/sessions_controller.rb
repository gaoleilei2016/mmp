# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout "users"
  skip_before_action :verify_authenticity_token
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    # p '~~~~~~~~~~~',current_user
    super
  end

  # POST /resource/sign_in
  def create
    if current_user
      case current_user.login
      when "cg"
        path = "/admin/home"
      when "cg1"
        path = "/hospital/home"
      when "cg2"
        path = "/ims/home"
      end
      return redirect_to path
    else
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

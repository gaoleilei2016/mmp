# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout "users"
  skip_before_action :verify_authenticity_token
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    flash[:login] = params[:login] if params[:login].present?
    build_resource
    yield resource if block_given?
    render "/devise/registrations/new.html.erb",layout:"customer"
    
    # # str = request.user_agent
    # # if str.include?('Mobile')
    # # else
    # #   respond_with resource,layout:"customer"
    # # end
    # super
  end

  # POST /resource
  def create
    # p '~~~~~~~~~',params
    params[:user] = {
      login:params[:login],
      password:params[:password],
      email:"#{params[:login]}@duanxinzhuce.tm",
      openid:session[:openid],
      openname:session[:openname],
    }
    build_resource(sign_up_params)
    # # 图片验证码
    # unless verify_rucaptcha?
    #   flash[:login] = params[:login]
    #   flash[:dxyz] = params[:dxyz]
    #   return render "/devise/registrations/new.html.erb",layout:"customer"
    # end
    # 短信验证码
    if params[:login].present?&&params[:dxyz].present?
      res = Sms::Message.find_and_verify(params[:login], params[:dxyz])
      if res[:state]!=:succ
        resource.errors.add(:base,"短信码错误：#{params[:dxyz]}")
        flash[:login] = params[:login]
        flash[:dxyz] = ""
        return render "/devise/registrations/new.html.erb",layout:"customer"
      end
    else
      resource.errors.add(:base,"手机号和短信码不能为空")
      return render "/devise/registrations/new.html.erb",layout:"customer"
    end
    # 如果是老用户，直接登录
    if u=(User.where(login:params[:login]).first)
      # 找回密码时的操作
      u.password = params[:password]
      u.save
      sign_in(u)
      return redirect_to "/"
    end
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length

      render "/devise/registrations/new2.html.erb",layout:"customer"
      # str = request.user_agent
      # if str.include?('Mobile')
        # p '@@@@@@@@@@@',resource.errors.messages
      # else
      #   respond_with resource
      # end

    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:sex,:birth])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

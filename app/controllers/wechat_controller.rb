#necoding: utf-8

class WechatController < ApplicationController
  skip_before_action :verify_authenticity_token

  layout false

  # 微信菜单登录设定
  # 登录调转到'/'; 未登录调转到'/users/sign_up'
  def login
    if wx_user_sign_in? #已经登录并且已登记过的
      session[:openid] = current_user.openid
      redirect_to '/'
    else
      res = Pay::Wechat.get_openid(params[:code])
      if res[:error] #获取openid失败的
        flash[:notice] = res[:msg]
        redirect_to '/users/sign_up'
      else
        session[:openid] = res[:openid]
        user = User.find_by(openid: res[:openid])
        if user
          sign_in(user)
          redirect_to '/'
        else
          redirect_to '/users/sign_up'
        end
      end
    end
  end

  #已登记过，但是未登录
  def rgistered
  end

  #已登录的
  def wx_user_sign_in?
    return true if current_user&&(!current_user.openid&.empty?)
    false
  end
end
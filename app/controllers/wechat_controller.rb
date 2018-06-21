#necoding: utf-8

class WechatController < ApplicationController
  skip_before_action :verify_authenticity_token

  layout false

  # 微信菜单登录设定
  # 登录调转到'/'; 未登录调转到'/users/sign_up'
  def login
    if wx_user_sign_in? #已经登录并且已登记过的
      p '111111111111111111111111'
      session[:openid] = current_user.openid
      redirect_to '/'
    else
      p '222222222222222222222222222222'
      res = Pay::Wechat.get_openid(params[:code])
      p res
      if res[:error] #获取openid失败的
        p '333333333333333333333333333333'
        flash[:notice] = res[:msg]
        redirect_to '/users/sign_up'
      else
        p '4444444444444444444444'
        session[:openid] = res[:openid]
        user = User.find_by(openid: res[:openid])
        p user
        if user
          p '5555555555555555555555555555'
          sign_in(user)
          redirect_to '/'
        else
          p '666666666666666666666666'
          redirect_to '/users/sign_up'
        end
      end
    end
  end

  def pay
    begin
      
    rescue Exception => e
      
    end
  end

  def write_log(msg)
    PayAndSmsLog.info(msg, {file_name: 'wechat'})
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
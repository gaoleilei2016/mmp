#necoding: utf-8

class WechatController < ApplicationController
  skip_before_action :verify_authenticity_token

  layout false

  # # 将用户数据推送到高登服务器
  # def wowgo
  #   res = current_user.push_wowgo
  #   render json: res
  # end

  # 微信菜单登录设定
  # 登录调转到'/'; 未登录调转到'/users/sign_up'
  def login
    p '~~~~~~~~~~~~~~ login customer_report_is_read to false current: ',session[:customer_report_is_read]
    session[:customer_report_is_read] = false
    if wx_user_sign_in? #已经登录并且已登记过的
      session[:openid] = current_user.openid
      session[:openname] = Set::Wechat.name
      redirect_to '/'
    else
      res = Pay::Wechat.get_openid(params[:code])
      if res[:error] #获取openid失败的
        raise res[:msg]
        # redirect_to '/users/sign_up'
      else
        session[:openid] = res[:openid]
        session[:openname] = Set::Wechat.name
        user = User.find_by(openid: res[:openid])
        if user
          sign_in(user)
          redirect_to '/'
        else
          flash[:notice] = '微信用户请先绑定手机.'
          redirect_to '/users/sign_up'
        end
      end
    end
  end

  def info
    res = nil
    begin
      raise '没有openid' unless current_user&.openid
      info = Pay::Wechat.get_wechat_info_by(current_user.openid)
      raise info.to_s unless info[:state].eql?(:succ)
      raise '获取信息成功,但更新失败' unless current_user.update_attributes({name: info[:res]['nickname'], headimgurl: info[:res]['headimgurl']})
      flash[:notice] = '成功获取用户微信信息'
      res = {state: :succ, msg: '成功'}
    rescue Exception => e
      res = {state: :error, msg: '错误', desc: e.message}
    end
    render json: res
  end

  def websocket
    uid = current_user.organization_id
    p '33333333333333333333333333333333', uid
    render json: {host: request.host_with_port, uid: uid}
  end

  # 已支付调用
  def pay
    begin
      write_log("-------微信公众号支付成功--更新数据-----#{params[:out_trade_no]}")
      order = Pay::Order.find_by(out_trade_no: params[:out_trade_no])
      res = if order
              return {state: :fail, msg: '已支付', desc: '订单已支付'} if order.status.eql?('success')
              if order.update_attributes({status: 'success', status_desc: '已支付'})
                Orders::Order.find(order.out_trade_no.split('_')[0]).order_settle("Wechat")
                {state: :success, msg: '数据更新成功'}
              else
                {state: :error, msg: '更新失败', desc: order.errors.full_messages.join(',')}
              end
            else
              {state: :error, msg: '订单不存在'}
            end
      write_log("------结果-----#{res.to_json}")
      render json: res.to_json
    rescue Exception => e
      res = {state: :error, msg: '系统错误', desc: e.message}
      render json: res.to_json
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
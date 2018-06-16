#necoding: utf-8

class PayController < ApplicationController
  skip_before_action :verify_authenticity_token

  layout false
  
  def confirm
    if params[:id]
      rec = Pay::Alipay.find_by(out_trade_no: params[:id]) if params[:type].eql?('Alipay')
      rec = Pay::Wechat.find_by(out_trade_no: params[:id]) if params[:type].eql?('Wechat')
      if rec&.paid?
        flash[:notice] = '订单已支付'
        redirect_to '/'
      else
        redirect_to "/customer/portal/pay?id=#{params[:id]}"        
      end
    else
      redirect_to '/'
    end
  end

  #接收微信支付通知
  def wechat
    begin
      xml = request.body.string
      write_log("----收到微信支付通知-----#{xml}")
      res = Hash.from_xml(xml)['xml']
      wx = Pay::Wechat.find_by(out_trade_no: res['out_trade_no'])
      return write_log("----订单未找到-#{res['out_trade_no']}----#{xml}") unless wx
      return write_log("----订单支付异常--#{res}---") unless res['return_code'].eql?('SUCCESS') && res['result_code'].eql?('SUCCESS')
      if wx.total_fee == res['total_fee'].to_i
        return write_log("-----订单已支付----#{res['out_trade_no']}") if wx.update_attributes({status: 'success', status_desc: '订单已支付'})
        write_log("------订单已支付但数据更新失败----原因:#{wx.errors.full_messages.join(',')}")
      else
        write_log("-----订单金额不等----#{res['out_trade_no']}----#{res['total_fee']}")
        wx.update_attributes({status: :fail, status_desc: '订单金额不等'})
      end
    rescue Exception => e
      write_log.info("----处理通知出错-----#{e.message}")
    end
    # respond_to do |f|
    #   f.json{ render json: 'true'}
    # end
    render json: 'true'
  end

  def write_log(msg)
    PayAndSmsLog.info(msg, {file_name: 'wechat'})
  end

  def write_ali_log(msg)
    PayAndSmsLog.info(msg, {file_name: 'alipay'})
  end

  # 接收支付宝支付通知
  # {"gmt_create"=>"2018-06-13 21:12:01", "charset"=>"UTF-8", "seller_email"=>"chengang@tenmind.com", 
  #   "subject"=>"花溪", "sign"=>"eWTMZwkfoV8HTZucjGoovd5OXt4ZNoyBjESlrYHkKcga1tRILWvCf3xiXGKz/WAcIACdtJvj4j74Xz1Go818hiWSqiSST/PUsQGrh+4GVqT3s7G5+xMaX1cYfSNTkZjpYZQuI7PtbhAVR+St6TezIXO+DBW+msJhqMzoGE05NWD/h4/HxAMA83C+hQpFZqyER+U4oMDJOPZTzw0gyYqXygyGABceHL87eRlYzKVL7tSGLpQ6JlEGfu4PGPNJGlwcAhxZusTJkWeSkcS3dWe5ySZ6BSH5At5rqTVPYQ8WM/6h9sPQtIUQcz86WZcPov/4d0axQSu5coTnT3S9Jn/ErA==", 
  #   "buyer_id"=>"2088402835578202", "invoice_amount"=>"0.01", "notify_id"=>"5c18ded2fc9820da407d4fad498436chjp", 
  #   "fund_bill_list"=>"[{\"amount\":\"0.01\",\"fundChannel\":\"ALIPAYACCOUNT\"}]", 
  #   "notify_type"=>"trade_status_sync", "trade_status"=>"TRADE_SUCCESS", 
  #   "receipt_amount"=>"0.01", "buyer_pay_amount"=>"0.01", "app_id"=>"2018060860345111", 
  #   "sign_type"=>"RSA2", "seller_id"=>"2088131503627051", "gmt_payment"=>"2018-06-13 21:12:02", 
  #   "notify_time"=>"2018-06-13 21:16:13", "version"=>"1.0", "out_trade_no"=>"201806131", 
  #   "total_amount"=>"0.01", "trade_no"=>"2018061321001004200577983202", "auth_app_id"=>"2018060860345111", 
  #   "buyer_logon_id"=>"992***@qq.com", "point_amount"=>"0.00", "controller"=>"pay", 
  #   "action"=>"alipay"}
  def alipay
    begin
      write_ali_log("------收到支付宝支付通知-----#{params.inspect}")
      ali = Pay::Alipay.find_by(out_trade_no: params['out_trade_no'])
      return write_ali_log("------订单未找到---#{params['out_trade_no']}") unless ali
      return write_ali_log("------订单未支付----#{params['trade_status']}") unless params['trade_status'].eql?('TRADE_SUCCESS')
      if params['total_amount'].to_f == ali.total_fee
        return write_log("-----订单已支付----#{params['out_trade_no']}") if ali.update_attributes({status: 'success', status_desc: '订单已支付'})
        write_log("------订单已支付但数据更新失败----原因:#{ali.errors.full_messages.join(',')}")
      else
        write_log("-----订单金额不等----#{params['out_trade_no']}----#{res['total_amount']}")
        wx.update_attributes({status: :fail, status_desc: '订单金额不等'})
      end
    rescue Exception => e
      write_log.info("----处理通知出错-----#{e.message}")
    end
    render json: 'true'
  end

  # 支付测试
  def wx
    num = rand(1000)
    args = {cost_name: '测试费', out_trade_no: "20180613#{num}", total_fee: 0.01, title: '花溪',
      return_url: 'http://mmp.tenmind.com/pay/index'}
    res = Pay::Wechat.payment(args)
    if res[:state].eql?(:succ)
      redirect_to res[:pay_url]
    else
      flash[:notice] = "#{res[:msg]}#{res[:desc]}"
      redirect_to '/pay/index'
    end
  end

  def ali
    args = {cost_name: '测试费', out_trade_no: '201806134', total_fee: 0.01, title: '花溪',
      return_url: 'http://mmp.tenmind.com/pay/index'}
    res = Pay::Alipay.payment(args)
    if res[:state].eql?(:succ)
      redirect_to res[:pay_url]
    else
      flash[:notice] = "#{res[:msg]}#{res[:desc]}"
      redirect_to '/pay/index'
    end
  end

  def index
    p 'tttttttttttttttt', request.remote_ip, request.remote_addr
  end
end
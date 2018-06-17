#encoding: utf-8

require 'grape'

module Pay
  class Api < Grape::API
    version 'v1', using: :header, vendor: 'pay'
    # format :json
    prefix :api

    helpers do
      def write_log(msg)
        PayAndSmsLog.info(msg, {file_name: 'wechat'})
      end
    end

    post :text do
      true
    end

    # {"appid"=>"wx985d4b9d7b2784d2", "bank_type"=>"CFT", "cash_fee"=>"1", 
    #   "fee_type"=>"CNY", "is_subscribe"=>"Y", "mch_id"=>"1432526502", 
    #   "nonce_str"=>"cptCx8YeOP5ttlIczy7SEODQMEVbdrfw", "openid"=>"omP0Dv7nqqgQWklIHisxkVhWgn1Y", 
    #   "out_trade_no"=>"20180613939", "result_code"=>"SUCCESS", 
    #   "return_code"=>"SUCCESS", "sign"=>"43D369EA56E356C570FB4553948EAB45", 
    #   "time_end"=>"20180613200532", "total_fee"=>"1", "trade_type"=>"MWEB", 
    #   "transaction_id"=>"4200000130201806134210210900"}
    post :wechat do
      xml = request.body.string
      p 'uuuuuuuuuuuuuuuuuuuuuuuu',xml
      write_log("----收到微信支付通知-----#{xml}")
      begin
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
      # true
    end

    # post :alipay do
    # end
  end
end
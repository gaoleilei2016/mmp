#encoding: utf-8

class Pay::Alipay < ApplicationRecord
  # api_name: '接口名称'

  def get_apiname_by_key(key)
    apiname = {
      phone: 'alipay.trade.wap.pay', #手机支付
      pay: 'alipay.trade.page.pay', #统一下单支付
      refund: 'alipay.trade.refund', #统计
    }
  end

  def url
    'https://openapi.alipay.com/gateway.do'
  end
end
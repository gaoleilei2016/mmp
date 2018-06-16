#关于支付宝的设置

class Set::Alibaba < Settingslogic
  source "#{Rails.root}/config/setup/pay/alipay.yml"
  namespace Rails.env
end
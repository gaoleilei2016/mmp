#关于微信的设置

class Set::Wechat < Settingslogic
  source "#{Rails.root}/config/setup/pay/wechat.yml"
  namespace Rails.env
end
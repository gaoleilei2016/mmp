#关于云片的设置

class Set::Yunpian < Settingslogic
  source "#{Rails.root}/config/setup/sms/yun_pian.yml"
  namespace Rails.env
end
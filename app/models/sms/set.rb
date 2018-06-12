class Sms::Set < Settingslogic
  source "#{Rails.root}/config/setup/sms/yun_pian.yml"
  namespace Rails.env
end
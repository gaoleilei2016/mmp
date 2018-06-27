#关于高登的调用设置

class Set::Wowgo < Settingslogic
  source "#{Rails.root}/config/setup/wowgo/health.yml"
  namespace Rails.env
end
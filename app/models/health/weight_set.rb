class Health::WeightSet < Settingslogic
  source "#{Rails.root}/config/setup/health/weight.yml"
  namespace Rails.env
end
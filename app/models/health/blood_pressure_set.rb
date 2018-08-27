class Health::BloodPressureSet < Settingslogic
  source "#{Rails.root}/config/setup/health/blood_pressure.yml"
  namespace Rails.env
end
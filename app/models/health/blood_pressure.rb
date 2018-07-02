#encoding: utf-8

#用户的血压 BMI计算
class Health::BloodPressure < ApplicationRecord
  self.table_name = 'health_blood_pressures'

  # systolic_value,  type: Integer, #收缩压
  # diastolic_value, type: Integer, #舒张压
  # code, string, #评分
  # state,           type: Symbol,  #
  # state_desc,      type: String,  #
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', optional: true

  def result
    {result: set.desc, systolic: systolic_value, diastolic: diastolic_value, }
  end

  def set
    Health::BloodPressureSet.send(code)
  end

  class << self
    def create_record(args)
      datas = handle_data(args)
      rec = new(datas)
      return {error: false, rec: rec} if rec.save
      {error: true, msg: rec.errors.full_messages.join(',')}
    end

    def handle_data(args)
      code = grade(args[:diastolic_value])
      args.merge({code: code, state: code})
    end

    def grade(diastolic_value)
      code = if (diastolic_value < 60) then :low
            elsif (diastolic_value >= 60) && (diastolic_value < 80)  then :ideal
            elsif (diastolic_value >= 80) && (diastolic_value < 85)  then :normal
            elsif (diastolic_value >= 85) && (diastolic_value <= 89) then :normal_high
            elsif (diastolic_value >= 90) && (diastolic_value <= 99) then :one_high
            elsif (diastolic_value >= 100) && (diastolic_value <= 109) then :two_high
            else :three_high end
      code
    end
  end
end
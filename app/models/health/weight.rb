#encoding: utf-8

#用户的weight BMI计算
class Health::Weight < ApplicationRecord
  self.table_name = 'health_weights'

  # sex,               type: String, #性别
  # age,               type: Float,  #年龄
  # bmi,               type: Float,  #bmi值
  # height,            type: Float,   #身高
  # code,  string #评分
  # data,              type: Float,   #体重
  # max_heart_rate,    type: String, #最高心率
  # normal_heart_rate, type: String, #最佳心率
  validates_presence_of :sex,    message: '性别必须存在' 
  validates_presence_of :age,    message: '年龄必须存在' 
  validates_presence_of :height, message: '身高必须存在' 
  validates_presence_of :data,   message: '体重必须存在' 

  belongs_to :user, class_name: 'User', foreign_key: 'user_id', optional: true

  def result
    { bmi: self.bmi, max_heart_rate: self.max_heart_rate, normal_heart_rate: self.normal_heart_rate,
     desc: set.desc, disease: set.disease, normal_diet: base_set.normal_diet, bad_diet: base_set.bad_diet,
     dietary_advice: set.dietary_advice, motion_intensity: base_set.motion_intensity, sport_events: base_set.sport_events}
  end

  def set
    Health::WeightSet.send(code)
  end

  def base_set
    Health::WeightSet
  end

  class << self
    # {sex: self.sex, age: age, height: handle_height, data: ws_weight.floWeight, user: user}
    def create_record(args)
      datas = handle_data(args)
      rec = new(datas)
      return {error: false, rec: rec} if rec.save
      {error: true, msg: rec.errors.full_messages.join(',')}
    end

    def handle_data(args)
      bmi = bmi_value(args[:data], args[:height])
      max_heart_rate = max_heart(args[:sex])
      normal_heart_rate = normal_heart(args[:age])
      code = get_wt_record(bmi)
      args.merge({bmi: bmi, max_heart_rate: max_heart_rate, normal_heart_rate: normal_heart_rate, code: code})
    end

    def get_wt_record(bmi)
      code =  if (bmi < 18.5)
                :thin
              elsif (bmi >= 18.5) && (bmi <= 23.9)
                :normal
              elsif (bmi >= 24) && (bmi <= 27.9)
                :fat
              else
                :obesity
              end
      code
    end

    #最高心率
    def max_heart(sex)
      case sex
      when '男'
        "#{205 - age}"
      when '女'
        "#{220 - age}"
      else
        '未知性别, 所以无法计算'
      end
    end

    #最佳心率
    def normal_heart(age)
      if age <= 45
        "#{sprintf('%.1f', (200 - age)*0.6)}~#{sprintf('%.1f', (200-age)*0.85)}"
      elsif (age > 45) && (age <= 60)
        "#{170 - age}"
      else
        "#{(170 - age)*0.9}"
      end
    end

    #计算体重BMI：体重(kg)除以身高(m)的平方
    def bmi_value(data, height)
      sprintf('%.1f', data/(height*height))
    end
  end
end
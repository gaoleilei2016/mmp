#encoding: utf-8

class Sms::Message < ApplicationRecord
  
  validates_presence_of :data_type, message: '短信类型必须存在'
  validates_presence_of :phone,     message: '手机号码不能为空'

  validates_inclusion_of :data_type, :in => %w{verify_code login_code}, :message => 'data_type错误'

  class << self
    def set_up(args) #{phone:'',data_type: 'verify_code', name: ''}
      rec = new(args.merge({code: new_random_code, expired_in: expired_time}))
      return write_log_return({state: :fail, msg: '创建记录错误', desc: rec.errors.full_messages.join(',')}) unless rec.save
      datas = handle_send_datas(rec)
      res = Sms::Data.send_phone(datas)
      res.merge({verify_code: rec.code})
    end

    def handle_send_datas(rec)
      case rec.data_type
      when 'verify_code'
        {type: rec.data_type, name: rec.phone, code: rec.code, hour: '5分钟', phone: rec.phone}
      when 'login_code'
        {type: :login_code, code: rec.code, phone: rec.phone}        
      else
        'new_code'
      end
    end

    def expired_time(min = 5)
      Time.now + min*60
    end

    def new_random_code(len = 4)
      chars = ('0'..'9').to_a
      newcode = ''
      1.upto(len){|i| newcode << chars[rand(chars.size - 1)]}
      newcode
    end

    def find_and_verify(phone, code)
      rec = find_by_sql("SELECT * FROM sms_messages WHERE phone='#{phone}' AND code='#{code}'").first
      return write_log_return({state: :fail, msg: '验证失败', desc: '验证码与手机不匹配'}) unless rec
      return write_log_return({state: :fail, msg: '验证失败', desc: '验证码已过期'}) if rec.expired?
      write_log_return({state: :succ, msg: '验证成功', desc: '验证码可用'})
    end

    def write_log_return(args)
      PayAndSmsLog.info("#{args[:state]}----#{args[:msg]}----#{args[:desc]}", {file_name: 'sms'})
      args    
    end
  end

  # 过期
  def expired?
    t  = Time.now
    t2 = Time.parse(expired_in)
    t > t2
  end
end

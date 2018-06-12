#关于云片的设置

require 'china_sms'

class Sms::Data

  # args = {type: :take_medic, name: '患者姓名', number:'处方单号', total_fee: '处方单总金额+单位',
  #   number1: '取药码', url: 'http连接', phone: '手机号码'}
  # args = {type: :verify_code, name: '用户名或登录名', code: '验证码', hour: '有效期:例如几分钟内', phone: '手机号码'}
  class << self
    def send_phone(args)
      write_log_return({msg: "发送短信开始-----#{args}"})
      return write_log_return({msg: "发送短信结束： 功能未开通"}) if !Sms::Set.usable
      return write_log_return({msg: "发送短信结束： 失败-----未知类型: #{args}"}) unless Sms::Set.tpl.keys.include?(args[:type].to_s)
      return write_log_return({msg: "发送短信结束： 失败-----手机号为空: #{args}"}) if args[:phone].nil? || args[:phone].empty?
      tpl_id = Sms::Set.tpl.send(args[:type].to_sym)
      phone = args[:phone]
      args.delete_if{|key, value| key.eql?(:type) || key.eql?(:phone)}
      ChinaSMS.use :yunpian, password: Sms::Set.apikey
      res = ChinaSMS.to phone, args, tpl_id: tpl_id
      value = handle_content(res)
      write_log_return({msg: "发送短信结束： 结果：#{value}================="})
      value
    end

    def handle_content(res)
      return {state: :succ, msg: '短信发送成功'}if res['code'].eql?(0)
      {state: :fail, msg: res['msg'], desc: res['detail']}
    end

    def write_log_return(args)
      PayAndSmsLog.info(args[:msg])
      args[:msg]    
    end
  end
end
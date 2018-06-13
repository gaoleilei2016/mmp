#encoding: utf-8

class Pay::Wechat < ApplicationRecord
  # content,out_trade_no
  class << self
    def payment(args)
      write_log_return({state: :start, msg: '支付宝付款开始'})
      return write_log_return({state: :fail, msg: '支付宝未开通', desc: '若已开通,请检查项目下的配置'}) unless Set::Alipay.usable
      payment = new(args)
      return write_log_return({state: :fail, msg: "创建支付记录报错", desc: e.message}) unless payment.save
      payment.get_payment_url
    end

    def write_log_return(msg)
      PayAndSmsLog.info("#{args[:state]}----#{args[:msg]}----#{args[:desc]}", {file_name: 'wechat'})
      args
    end
  end

  def get_payment_url
    args = {
      appid: wx.appid,
      mch_id: wx.mchid,
      nonce_str: new_pass(32),
      sign_type: wx.sign_type,
      body: content,
      out_trade_no: out_trade_no,
      total_fee: total_fee,
      spbill_create_ip: wx.spbill_ip,
      notify_url: wx.notify_url,
      trade_type: wx.trade_type,
      scene_info: get_scene_info
    }
    datas = handle_send_datas(args)
    res = send_data(wx.pay_url, datas)
    return self.class.write_log_return({state: :succ, msg: '请转到微信支付',  pay_url: res['mweb_url']) if @res['result_code'].eql?('SUCCESS')
    self.class.write_log_return({state: :fail, msg: '支付失败', desc: "#{res['return_msg']}:#{res['err_code_des']}"})
  end

  # 微信设置
  def wx
    Set::Wechat
  end

  #生成随机字符
  def new_pass(len) #len位数
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    newpass
  end

  def send_data(url, datas)
    Hash.from_xml(RestClient.post(url, datas).body)['xml']
  end

  def get_scene_info
    {"h5_info": {"type": "Wap","wap_url": wx.wap_url,"wap_name": wx.wap_name}}
  end

  # 根据发送的数据生成sign并且生成xml格式发送字符串
  def handle_send_datas(data_hash = {})
    data = data_hash.sort.to_h
    arr_data = []
    data.each do |key, value|
      next if value.nil? || value.blank?
      arr_data << "#{key}=#{value}"
    end
    sign = md5_sign(arr_data.join('&'))
    data[:sign] = sign
    p data
    xml_data = hash_to_xml(data) #data.to_xml(root: 'xml')
  end

  def hash_to_xml(datas)
    str = '<xml>'
    datas.each{|key, value| str += "<#{key}>#{value}</#{key}>"}
    str += '</xml>'
  end

  # md5签名
  def md5_sign(data)
    str = data + "&key=#{wx.pay_key}"
    OpenSSL::Digest::MD5.hexdigest(str).upcase
  end
end
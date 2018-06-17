#encoding: utf-8

require 'rest-client'

class Pay::Wechat < ApplicationRecord
  self.table_name = 'pay_wechats'

  validates_presence_of :out_trade_no, message: '订单号不能为空'
  validates_presence_of :total_fee,    message: '订单金额不能为空'
  validates_presence_of :title,        message: '订单标题不能为空'

  # cost_name(费用类别),
  # return_url(支付后返回路径)
  # status(订单状态 为success时是已支付)
  # status_desc(订单状态描述)
  class << self
    def payment(args)
      begin
        write_log_return({state: :start, msg: '微信付款开始'})
        return write_log_return({state: :fail, msg: '微信支付未开通', desc: '若已开通,请检查项目下的配置'}) unless Set::Wechat.usable
        payment = new(args.merge({total_fee: handle_order_total_fee(args[:total_fee])}))
        return write_log_return({state: :fail, msg: "创建支付记录报错", desc: e.message}) unless payment.save
        payment.get_payment_url        
      rescue Exception => e
        write_log_return({state: :fail, msg: "系统错误", desc: e.message})
      end
    end

    #处理支付金额
    def handle_order_total_fee(total_fee)
      num = (total_fee.to_f*100 + 0.001).round(2) #将元转为分
      return num.to_i if valid_total_fee?(num) #以分为单位的数字是否合法
      raise '支付金额的最小单位为分, 输入金额不合法.'
    end

    #判断金额的合法性
    def valid_total_fee?(total_fee)
      num_arr = total_fee.to_s.split('.')
      num_arr[1].to_i == 0 #最小单位是分,所以小数点后的数字为0
    end

    def write_log_return(args)
      PayAndSmsLog.info("#{args[:state]}----#{args[:msg]}----#{args[:desc]}", {file_name: 'wechat'})
      args[:rec].update_attributes({status: args[:state], status_desc: "#{args[:msg]}#{args[:desc]}"}) if args[:rec]
      args
    end
  end

  def get_payment_url
    args = {
      appid: wx.appid,
      mch_id: wx.mchid,
      nonce_str: new_pass(32),
      sign_type: wx.sign_type,
      body: title,
      out_trade_no: out_trade_no,
      total_fee: total_fee,
      spbill_create_ip: wx.spbill_ip,
      notify_url: wx.notify_url,
      trade_type: wx.trade_type,
      scene_info: get_scene_info
    }
    datas = handle_send_datas(args)
    self.class.write_log_return({state: :send, msg: '发送数据', desc: datas})
    res = send_data(wx.pay_url, datas)
    return self.class.write_log_return({rec: self, state: :fail, msg: '支付失败', desc: "#{res['return_msg']}:#{res['err_code_des']}"}) unless res['result_code'].eql?('SUCCESS')
    return self.class.write_log_return({rec: self, state: :succ, msg: '请求成功, 请转到微信支付',  pay_url: res['mweb_url']}) if return_url.empty?
    self.class.write_log_return({rec: self, state: :succ, msg: '请转到微信支付',  pay_url: "#{res['mweb_url']}&redirect_url=#{return_url}"})
  end

  # 微信设置
  def wx
    Set::Wechat
  end

  def paid?
    status.eql?('success')
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
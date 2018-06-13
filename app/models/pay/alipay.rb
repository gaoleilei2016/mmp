#encoding: utf-8

require 'alipay'

class Pay::Alipay < ApplicationRecord
  # cost_name,out_trade_no,total_fee,title,return_url,status,status_desc
  class << self
    # {return_url: '返回url(String)',out_trade_no: '订单号唯一(String)',title:'标题(String)',
    #   total_fee:'支付金额单位元(String)'}
    def payment(args)
      write_log_return({state: :start, msg: '支付宝付款开始'})
      return write_log_return({state: :fail, msg: '支付宝未开通', desc: '若已开通,请检查项目下的配置'}) unless Set::Alipay.usable
      payment = new(args)
      return write_log_return({state: :fail, msg: "创建支付记录报错", desc: e.message}) unless payment.save
      payment.get_payment_url
    end

    def write_log_return(msg)
      PayAndSmsLog.info("#{args[:state]}----#{args[:msg]}----#{args[:desc]}", {file_name: 'alipay'})
      args
    end
  end

  def get_payment_url
    begin
      client = Alipay::Client.new(
          url: ali.url,
          app_id: ali.app_id,
          app_private_key: read_the_file(ali.private_key_root),
          alipay_public_key: read_the_file(ali.public_key_root)
        )
      payment_url = client.page_execute_url(
        method: ali.api_name,
        return_url: get_return_url,
        notify_url: ali.notify_url,
        biz_content: {
          out_trade_no: out_trade_no,
          product_code: ali.product_code,
          total_amount: total_fee,
          subject: title,
          quit_url: get_return_url
        }.to_json(ascii_only: true),
        timestamp: current_time
      )
      return self.class.write_log_return({ state: :succ, msg: '请转到支付宝支付',  pay_url: payment_url }) if payment_url&.include?('https://mclient.alipay.com')
      self.class.write_log_return({state: :fail, msg: '支付失败', desc: payment_url})
    rescue Exception => e
      self.class.write_log_return({state: :fail, msg: "支付错误", desc: e.message})
    end
  end

  private

  def get_return_url
    return return_url if return_url && !return_url.empty?
    ali.return_url
  end

  def current_time
    Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end

  def ali
    Set::Alipay
  end

  def base_set
    {product_code: ali.product_code, quit_url: ali.notify_url}
  end

  def read_the_file(file_root)
    File.read(file_root)
  end

  #----------------------------
  # rsa签名，文本内容和私钥路径
  def rsa_sign(data,private_key_path)
    private_key = File.read(private_key_path)
    pri = OpenSSL::PKey::RSA.new(private_key)
    sign = pri.sign('sha1', data.force_encoding("utf-8"))
    # signature = CGI.escape(Base64.encode64(sign))
    signature = Base64.encode64(sign)
    # signature = signature.delete("\n","\r")
    signature = signature.delete("\n").delete("\r")
    return signature
  end

  # rsa验签，文本内容和签名内容，公钥路径
  def rsa_verify(data,sign,public_key_path)
    public_key = File.read(public_key_path)
    pub = OpenSSL::PKey::RSA.new public_key
    digester = OpenSSL::Digest::SHA1.new
    sign = Base64.decode64(sign)
    return pub.verify(digester, sign, data)
  end

  # rsa签名验签测试
  def test_rsa
    data = "123"
    puts rsa_sign(data,'rsa_private_key.pem')

    sign= "KrXGYocurl3wl6w96dkr906lE1RErlQS2T5zalFIALR6Re78qCQlihIN+iXDyQK6OKc8sQlWUgdARslL0n1WFGM36OWZfhb2dG4mpFaKE3oq88JSrxTR0uAQrR/m13qe5QxpN30gCsrNlAqSlUER8TS8cfI9eWtkTQqz6TWaGio="
    puts rsa_verify(data,sign,'rsa_public_key.pem')
  end

  def handle_reqdatas(args)
    datas = args.sort.to_h
    arr_data = []
    datas.each do |key, value|
      next if value.nil? || value.blank?
      arr_data << "#{key}=#{value}"
    end
    sign = md5_sign(arr_data.join('&'))
    datas[:sign] = sign
  end

  def url
    'https://openapi.alipay.com/gateway.do'
  end

  def args
    {
      app_id: '2018060860325957',
      method: 'alipay.trade.wap.pay',
      format: 'JSON',
      charset: 'utf-8',
      sign_type: 'RSA2',
      sign: '',
      timestamp: current_time,
      version: '1.0',
      notify_url: 'http://mmp.tenmind.com/pay/alipay',
      biz_content: ''
    }
  end

  def body
    {
      body: '测试一下支付嘛',
      subject: '药品',
      out_trade_no: '123456',
      timeout_express: '1d'
      total_amount: 0.01,
      product_code: '2018060810537243'
    }
  end
end
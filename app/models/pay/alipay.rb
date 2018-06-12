#encoding: utf-8

class Pay::Alipay < ApplicationRecord
  # api_name: '接口名称'

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

  def current_time
    Time.now.strftime("%Y-%m-%d %H:%M:%S")
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
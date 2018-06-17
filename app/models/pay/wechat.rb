#encoding: utf-8

require 'rest-client'

class Pay::Wechat

  class << self
    def refund(ref)
      datas = handle_send_datas(refund_datas(ref))
      res = send_cert_data(datas)
      if res['return_code'].eql?('SUCCESS')&&res['result_code'].eql?('SUCCESS')
        ref.update_attributes({status: 'succ', status_desc: '退款提交成功,等待退款'})
        {state: :succ, msg: '请求成功', desc: '退款提交成功,等待退款'}
      else
        ref.update_attributes({status: :fail, status_desc: res['err_code_des']})
        {state: :fail, msg: '退款失败', desc: res['err_code_des']}
      end      
    end

    def refund_datas(ref)
      {
        appid: wx.appid, mch_id: wx.mchid, nonce_str: new_pass(32), sign_type: 'MD5',
        out_refund_no: ref.out_refund_no, out_trade_no: ref.order.out_trade_no, 
        total_fee: handle_order_total_fee(ref.order.total_fee), refund_fee: handle_order_total_fee(ref.refund_fee),
        refund_desc: ref.reason, notify_url: wx.refund_notify_url
      }
    end    

    # 在服务器上导出
    # openssl pkcs12 -clcerts -nokeys -in apiclient_cert.p12 -out apiclient_cert.pem
    # openssl pkcs12 -nocerts -in apiclient_cert.p12 -out apiclient_key.pem
    def send_cert_data(datas)
      uri = URI(wx.refund_url)

      file_root = "#{Rails.root}#{wx.cert_root}"
      cert_cont = File.read(file_root)
      p12       = OpenSSL::PKCS12.new(cert_cont, wx.mchid.to_s)
      pk12_cert = p12.certificate.to_s
      pk12_key  = p12.key.to_s
      cert      = OpenSSL::X509::Certificate.new(pk12_cert)
      key       = OpenSSL::PKey::RSA.new(pk12_key)

      https             = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl     = true
      https.cert        = cert
      https.key         = key
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req      = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' => 'text/xml'})
      req.body = datas
      res      = https.request(req)

      Hash.from_xml(res.body)['xml']
    end

    def payment(args)
      begin
        write_log_return({state: :start, msg: '微信付款开始'})
        return write_log_return({state: :error, msg: '无效的金额', desc: '支付金额必须大于等于0.01'}) unless args[:total_fee].to_f >= 0.01
        return write_log_return({state: :fail, msg: '微信支付未开通', desc: '若已开通,请检查项目下的配置'}) unless Set::Wechat.usable
        order = Pay::Order.new(args.merge({pay_type: 'wechat'}))
        return write_log_return({state: :fail, msg: "创建支付记录报错", desc: e.message}) unless order.save
        get_payment_url(order)     
      rescue Exception => e
        write_log_return({state: :fail, msg: "系统错误", desc: e.message})
      end
    end

    def refund_query()
    end

    def order_query()
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

    def get_payment_url(order)
      args = {
        appid: wx.appid,
        mch_id: wx.mchid,
        nonce_str: new_pass(32),
        sign_type: wx.sign_type,
        body: order.title,
        out_trade_no: order.out_trade_no,
        total_fee: handle_order_total_fee(order.total_fee),
        spbill_create_ip: wx.spbill_ip,
        notify_url: wx.notify_url,
        trade_type: wx.trade_type,
        scene_info: get_scene_info
      }
      datas = handle_send_datas(args)
      write_log_return({state: :send, msg: '发送数据', desc: datas})
      res = send_data(wx.pay_url, datas)
      return write_log_return({rec: order, state: :fail, msg: '支付失败', desc: "#{res['return_msg']}:#{res['err_code_des']}"}) unless res['result_code'].eql?('SUCCESS')
      return write_log_return({rec: order, state: :succ, msg: '请求成功, 请转到微信支付',  pay_url: res['mweb_url']}) if order.return_url.empty?
      write_log_return({rec: order, state: :succ, msg: '请求成功, 请转到微信支付',  pay_url: "#{res['mweb_url']}&redirect_url=#{order.return_url}"})
    end

    def get_openid(code)
      url = get_openid_url(code)
      op = get_user_openid(url)
      return { error: false, openid: op['openid'], msg: '成功获取openid' } if op['openid']
      { error: true, msg: "无法获取用户的openid: #{op['errmsg']}" }
    end

    def get_openid_url(code)
      "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{wx.appid}&secret=#{wx.appsecret}&code=#{code}&grant_type=authorization_code"
    end

    def get_user_openid(url)
      begin
        JSON.parse(RestClient.get(url).body)
      rescue SocketError => e
        { 'errmsg' => '无法连接微信服务器' }      
      rescue Exception => e
        { 'errmsg' => e.message }
      end
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
end
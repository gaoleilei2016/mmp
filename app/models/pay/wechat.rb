#encoding: utf-8

require 'rest-client'
require 'digest/md5'

class Pay::Wechat

  class << self
    # 退款
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
        total_fee: handle_order_total_fee(ref.order.total_fee.to_f), refund_fee: handle_order_total_fee(ref.refund_fee.to_f),
        refund_desc: ref.reason, notify_url: wx.refund_notify_url
      }
    end

    # {"out_refund_no"=>"1529371940", "out_trade_no"=>"205", "refund_account"=>"REFUND_SOURCE_UNSETTLED_FUNDS", 
    #   "refund_fee"=>"1", "refund_id"=>"50000207132018061905135218977", "refund_recv_accout"=>"支付用户零钱", 
    #   "refund_request_source"=>"API", "refund_status"=>"SUCCESS", "settlement_refund_fee"=>"1", 
    #   "settlement_total_fee"=>"1", "success_time"=>"2018-06-19 09:32:23", "total_fee"=>"1", 
    #   "transaction_id"=>"4200000134201806198379455778"}
    def refund_callback_value(req_info)
      begin
        str = Base64.decode64(req_info) #先对结果进行base64解码
        aes_data = aes_ecb_decrypt(str) #得到xml字符串
        res = Hash.from_xml(aes_data)['root']
        {error: false, res: res}
      rescue Exception => e
        {error: true, state: :fail, msg: e.message}
      end
    end

    def aes_ecb_decrypt(req_info)
      aes = OpenSSL::Cipher::AES.new("256-ECB")
      aes.decrypt
      aes.key = md5_pay_key
      aes.update(req_info) + aes.final
    end

    def md5_pay_key
      Digest::MD5.hexdigest(wx.pay_key)
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

    # H5支付
    def payment(args)
      begin
        write_log_return({state: :start, msg: '微信付款开始'})
        return write_log_return({state: :error, msg: '无效的金额', desc: '支付金额必须大于等于0.01'}) unless args[:total_fee].to_f >= 0.01
        return write_log_return({state: :fail, msg: '微信支付未开通', desc: '若已开通,请检查项目下的配置'}) unless Set::Wechat.usable
        order = Pay::Order.find_by(out_trade_no: args[:out_trade_no]) #查找订单
        return write_log_return({state: :fail, msg: '已支付', desc: '订单已支付'}) if order&.status&.eql?('success')
        return get_payment_url(order) if order #如果订单已存在就直接支付
        order = Pay::Order.new(args.merge({pay_type: 'wechat', trade_type: 'WEB'}))
        return write_log_return({state: :fail, msg: "创建支付记录报错", desc: order.errors.full_messages.join(',')}) unless order.save
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
        total_fee: handle_order_total_fee(order.total_fee.to_f),
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

    #公众号支付
    # args = {out_trade_no: '', total_fee: 0.0, title: '', cost_name: '', openid: ''}
    def public_pay(args)
      begin
        write_log_return({state: :start, msg: '微信公众号付款开始', desc: args.to_s})
        return write_log_return({state: :error, msg: '无效的金额', desc: '支付金额必须大于等于0.01'}) unless args[:total_fee].to_f >= 0.01
        return write_log_return({state: :fail, msg: '微信支付未开通', desc: '若已开通,请检查项目下的配置'}) unless Set::Wechat.usable
        order = Pay::Order.find_by(out_trade_no: args[:out_trade_no]) #查找订单
        return write_log_return({state: :fail, msg: '已支付', desc: '订单已支付'}) if order&.status&.eql?('success')
        return public_info(order) if order
        order = Pay::Order.new(args.merge({pay_type: 'wechat', trade_type: 'JSAPI'}))
        return write_log_return({state: :error, msg: '创建支付记录报错', desc: order.errors.full_messages.join(',')}) unless order.save
        public_info(order)
      rescue Exception => e
        write_log_return({state: :error, msg: '系统错误', desc: e.message})
      end
    end

    def public_info(order)
      datas = {appid: wx.appid, mch_id: wx.mchid, nonce_str: new_pass(32), sign_type: 'MD5', body: order.title,
        out_trade_no: order.out_trade_no, total_fee: handle_order_total_fee(order.total_fee.to_f), spbill_create_ip: wx.spbill_ip, notify_url: wx.notify_url,
      openid: order.openid, trade_type: 'JSAPI'}

      ret = handle_send_datas(datas)
      res = Hash.from_xml(RestClient.post(wx.pay_url, ret).body)['xml']
      p '2222222222222222222222222222', res
      data = {}
      if res['err_code_des'].eql?('该订单已支付')
        data = { state: :success, msg: '支付成功', desc: '支付已完成'}
      elsif res['return_code'].eql?('SUCCESS')
        data = { state: :succ, msg: '成功提交', desc: '成功提交支付, 等待用户支付中', prepay_id: res['prepay_id'] }
      else
        data = { state: :fail, msg: '请求失败', desc: "#{res['err_code_des']}" }
      end
      write_log_return(data)
      if order.update_attributes({status: data[:state], status_desc: data[:desc]})
        if data[:state].eql?(:succ)
          pay = {appId: wx.appid, timeStamp: Time.now.to_i, nonceStr: new_pass(32), package: "prepay_id=#{prepay_id}", signType: 'MD5'}
          data.merge(pay).merge({sign: handle_jsapi_datas(pay)})
        else
          data
        end
      else
        { state: :error, msg: '保存报错', desc: "#{order.errors.full_messages.join(',')}" }
      end
    end

    def handle_jsapi_datas(data)
      data = data.sort.to_h
      arr_data = []
      data.each do |key, value|
        next if value.nil? || value.blank?
        arr_data << "#{key}=#{value}"
      end
      md5_sign(arr_data.join('&'))
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
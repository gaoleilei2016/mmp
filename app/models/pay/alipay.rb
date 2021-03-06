#encoding: utf-8

require 'alipay'

class Pay::Alipay

  class << self
    def refund(ref)
      client   = get_client
      res = client.execute(
              method: ali.refund_api,
              biz_content: {
                out_trade_no: ref.order.out_trade_no,
                out_request_no: ref.out_refund_no,
                refund_amount: ref.refund_fee.to_f,
                notify_url: ali.refund_notify_url
              }.to_json(ascii_only: true)
            )
      result = JSON.parse(res)['alipay_trade_refund_response']
      ret = handle_refund_response(result)
      ref.update_attributes({status: ret[:state], status_desc: ret[:desc]})
      ret
    end

    def handle_refund_response(args)
      return {state: :success, msg: '成功', desc: '退款成功'} if args['code'].eql?('10000')&&args['fund_change'].eql?('Y')
      {state: :fail, msg: '退款失败', desc: args['msg']}
    end

    # {return_url: '返回url(String)',out_trade_no: '订单号唯一(String)',title:'标题(String)',
    #   total_fee:'支付金额单位元(String)'}
    def payment(args)
      begin
        write_log_return({state: :start, msg: '支付宝付款开始', desc: args.to_s})
        return write_log_return({state: :error, msg: '无效的金额', desc: '支付金额必须大于等于0.01'}) unless args[:total_fee].to_f >= 0.01
        return write_log_return({state: :fail, msg: '支付宝未开通', desc: '若已开通,请检查项目下的配置'}) unless Set::Alibaba.usable
        order = Pay::Order.find_by(out_trade_no: args[:out_trade_no]) #查找订单
        return write_log_return({state: :fail, msg: '已支付', desc: '订单已支付'}) if order&.status&.eql?('success')
        return get_payment_url(order) if order #如何订单存在就直接支付
        order = Pay::Order.new(args.merge({pay_type: 'alipay', trade_type: 'WEB'}))
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

    def write_log_return(args)
      PayAndSmsLog.info("#{args[:state]}----#{args[:msg]}----#{args[:desc]}", {file_name: 'alipay'})
      args[:rec].update_attributes({status: args[:state], status_desc: args[:msg]}) if args[:rec]
      args
    end

    def get_client
      client = Alipay::Client.new(
          url: ali.url,
          app_id: ali.app_id,
          app_private_key: read_the_file(ali.private_key_root),
          alipay_public_key: read_the_file(ali.public_key_root)
        )
      client   
    end

    def get_payment_url(order)#order.return_url
      begin
        client = get_client
        payment_url = client.page_execute_url(
          method: ali.api_name,
          return_url: order.return_url,
          notify_url: ali.notify_url,
          biz_content: {
            out_trade_no: order.out_trade_no,
            product_code: ali.product_code,
            total_amount: order.total_fee.to_f,
            subject: order.title,
            quit_url: 'http://mmp.tenmind.com/pay'
          }.to_json(ascii_only: true),
          timestamp: current_time
        )
        return write_log_return({rec: order, state: :succ, msg: '请求成功,请转到支付宝支付',  pay_url: payment_url }) if payment_url&.include?('https')
        write_log_return({rec: order, state: :fail, msg: '支付失败', desc: payment_url})
      rescue Exception => e
        write_log_return({rec: order, state: :fail, msg: "支付错误", desc: e.message})
      end
    end

    def page_pay_url(order)#order.return_url
      begin
        client = get_client
        payment_url = client.page_execute_url(
          method: 'alipay.trade.page.pay',
          return_url: order.return_url,
          notify_url: ali.notify_url,
          biz_content: {
           out_trade_no: order.out_trade_no,
           product_code: ali.product_code,
           total_amount: order.total_fee.to_f,
           subject: 'Example #123',
          }.to_json(ascii_only: true),
        )
        return write_log_return({rec: order, state: :succ, msg: '请求成功,请转到支付宝支付',  pay_url: payment_url }) if payment_url&.include?('https')
        write_log_return({rec: order, state: :fail, msg: '支付失败', desc: payment_url})
      rescue Exception => e
        write_log_return({rec: order, state: :fail, msg: "支付错误", desc: e.message})
      end
    end

    def current_time
      Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    def ali
      Set::Alibaba
    end

    def base_set
      {product_code: ali.product_code, quit_url: ali.notify_url}
    end

    def read_the_file(file_root)
      File.read(file_root)
    end

    def app_pay(args)
      begin
        write_log_return({state: :start, msg: '支付宝APP付款开始', desc: args.to_s})
        return write_log_return({state: :error, msg: '无效的金额', desc: '支付金额必须大于等于0.01'}) unless args[:total_fee].to_f >= 0.01
        return write_log_return({state: :fail, msg: '支付宝未开通', desc: '若已开通,请检查项目下的配置'}) unless Set::Alibaba.usable
        order = Pay::Order.find_by(out_trade_no: args[:out_trade_no]) #查找订单
        return write_log_return({state: :fail, msg: '已支付', desc: '订单已支付'}) if order&.status&.eql?('success')
        return get_apppay_orderstr(order) if order #如何订单存在就直接支付
        order = Pay::Order.new(args.merge({pay_type: 'alipay', trade_type: 'WEB'}))
        return write_log_return({state: :fail, msg: "创建支付记录报错", desc: order.errors.full_messages.join(',')}) unless order.save
        get_apppay_orderstr(order)
      rescue Exception => e
        write_log_return({state: :fail, msg: "系统错误", desc: e.message})
      end
    end

    def get_apppay_orderstr(order)
      begin
        params = {'biz_content' => {'product_code' => ali.product_code, 'subject' => order.title, 
          'out_trade_no' => order.out_trade_no, 'total_amount' => order.total_fee.to_f}}
        new_hash = prepare_params(params)
        orderstr = params_to_encode(new_hash)
        {rec: order, state: :succ, msg: 'APP支付生成签名成功', orderstr: orderstr}
      rescue Exception => e
        {rec: order, state: :fail, msg: 'APP支付生成签名失败', desc: e.message}
      end
    end

    # APP支付的公用参数
    def public_params
      # t = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      {
        'app_id' => ali.app_id, 'method' => ali.app_pay_name, 'format' => ali.format, 'charset' => ali.charset,
        'sign_type' => ali.sign_type, 'timestamp' => current_time, 'version' => ali.version, 'notify_url' => ali.notify_url
      }
    end

    def prepare_params(params)
      args = public_params.merge(stringify_keys(params))
      string = params_to_string(args)
      key = File.read(ali.private_key_root)
      args['sign'] = RSA.sign(key, string)
      args
    end

    def params_to_encode(params)
      p '11111111111111111111', params
      params.sort.map do |key, value|
        "#{key}=#{value.to_s.encode('utf-8')}"
      end.join('&')
    end

    def params_to_string(params)
      # params.sort.map {|item| item.join('=')}.join('&')
      params.sort.map { |key, value| %Q(#{key}=#{value}) }.join('&')
    end

    def stringify_keys(args)
      new_hash = {}
      args.each do |key, value|
        new_hash[(key.to_s rescue key) || key] = value
      end
      new_hash
    end

    class RSA
      class << self
        def new_rsa(key)
          OpenSSL::PKey::RSA.new(key)
        end

        # RSA2生成签名和验签
        def sign(key, string) #key私钥值
          rsa = new_rsa(key)
          Base64.strict_encode64(rsa.sign('sha256', string))
        end

        def verify?(key, string, sign) #key是公钥值
          rsa = new_rsa(key)
          rsa.verify('sha256', Base64.strict_decode64(sign), string)
        end
      end
    end
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
    signature.delete("\n").delete("\r")
  end

  # rsa验签，文本内容和签名内容，公钥路径
  def rsa_verify(data,sign,public_key_path)
    public_key = File.read(public_key_path)
    pub = OpenSSL::PKey::RSA.new public_key
    digester = OpenSSL::Digest::SHA1.new
    sign = Base64.decode64(sign)
    pub.verify(digester, sign, data)
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
end
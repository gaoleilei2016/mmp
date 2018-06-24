#necoding: utf-8

class RefundController < ApplicationController
  skip_before_action :verify_authenticity_token

  layout false

  # 接收微信的退款通知
  # "<xml><return_code>SUCCESS</return_code><appid><![CDATA[wx985d4b9d7b2784d2]]></appid><mch_id><![CDATA[1432526502]]></mch_id><nonce_str><![CDATA[c9b517346a4ce98bdd1f4eb81ba9ae60]]></nonce_str><req_info><![CDATA[79j/NUCX2iGhIJXQ6s0HR4YnMChRPaY9BXJYFFenMCQA7GrkYkwaf2FmE+4mw6KU/COcXB6vDUZPUD58C4r7kc+UZ+s/58iQBTCq8eTWBeSOzJ1odK9JcGOsbf3CmL1ixJz9otayoN7smmxdXUErYcDaX2hqagKeAVyunfx6GU35JnGaZFjEWLG/kYtDaRbYB882fvU9QdE4Iie2mG26Nx1Rki7XPUkdKZsmPNVwYyCLQxpLUZiRwHl+X/cYAD0n/zwPrOQYCGdhtK3mBPVeefJRYW7Jt4u4o16IUSYQby7kHz19rGjEgGCoD+mfLj2mT0bRa/JKO/cnnykI6cDIypOjoQ5o37Ey3jQYQZOoCV6oDAmJUZQT0MQKv7cNbh0cqIr+gR2GfoKAtsrm8xJVOw3Zh1YCCyrDrdXUnsgv39x0kbwLRNEF6NFFyf+52dv1ocxJgQ6y/ZVRQz9m6sZ6jAodZxXDse2jf5pW6kzBSWn4aQFDgjCIZEXHz0OGSiqhr1xmWvywC5w5U2T2vNaPJAghuvzubakVbSa7HogDg11fVuq6IeF47JwFmm5vhFBJAe3y3Wuw7FMXPCNNdzVFk1i7veHVcW4PiFBzROMDLUUoC/BD3TSZwKr/lij4z8FqkxLws3EfIyxStg1LHZYCqMQSs3kRG8Oaxw1svoGV1V+D+SkpjPsMg3kHwcZJB8FcHZB5VzE9+tyJ78U/3WcsBH0goCO09zKXLaidNZqrD0ryhVj+DFxkLkb7R0dNkQVqXmOTk+OysmFbjp1urR41L8CrGXCbDLpLIuACSoKl05njHxRqHPExufe6SVN78OZ/AxHnCOXRVh4+hbz6f1UskXE8CC9keO4/ahBc+39v/fFeb/bTQBi01sFjTh2JD5XrqUgmHzxdjmZElMTz8HPPLV0e8WBmCPql4hNHw7Liv4D9pjoh87eLvNEw2SF9Wka63Wz/BqRev+3e9Ne5z7b3iYWub4rc3GYQfbhVyV1AHpSF4eKpROxP6tbxW6A7grM+gYzUdmMxR1aKOymwlsVQJg==]]></req_info></xml>"
  # Orders::Order.find('订单号').cancel_order()
  def wechat
    begin
      xml = request.body.string
      res = Hash.from_xml(xml)['xml']
      write_log_return({state: :notify_wechat, msg:'退款通知', desc: res})
      value = Pay::Wechat.refund_callback_value(res['req_info']) 
      write_log_return({state: :decrypt, msg: '解密结果', desc: value.to_json})     
      return if value[:error]
      ref = Pay::Refund.find_by(out_refund_no: value[:res]['out_refund_no'])
      return write_log_return({state: :notfund, msg: '退款单号错误', desc: '未找到退款单'}) unless ref
      return write_log_return({state: :error_status, msg: '失败', desc: '退款失败'}) unless value[:res]['refund_status'].eql?('SUCCESS')
      return write_log_return({state: :error_fee, msg: '错误', desc: '退款金额错误'}) unless (ref.refund_fee.to_f*100).round.eql?(value[:res]['refund_fee'])
      return write_log_return({state: :success, msg:'成功', desc: '退款成功'}) if ref.update_attributes({status: :success, status_desc: value[:res]['refund_recv_accout']})
      write_log_return({state: :fail, msg: '退款成功但更新数据库记录出错', desc: ref.errors.full_messages.join(',')})
      render json: {return_code: 'SUCCESS', return_msg: 'OK'}.to_json
    rescue Exception => e
      write_log_return({state: :error, msg: '退款处理出错', desc: e.message})
    end
  end

  # 接收支付宝的退款通知
  def alipay
    xml = request.body.string
    p '11111111111111111111111111', params
    p '22222222222222222222222222', xml
  end

  def write_log_return(args)
    PayAndSmsLog.info("#{args[:state]}----#{args[:msg]}----#{args[:desc]}", {file_name: 'refund'})
    args
  end
end
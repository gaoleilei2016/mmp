#necoding: utf-8

class RefundController < ApplicationController
  skip_before_action :verify_authenticity_token

  layout false

  # 接收微信的退款通知
  # "<xml><return_code>SUCCESS</return_code><appid><![CDATA[wx985d4b9d7b2784d2]]></appid><mch_id><![CDATA[1432526502]]></mch_id><nonce_str><![CDATA[c9b517346a4ce98bdd1f4eb81ba9ae60]]></nonce_str><req_info><![CDATA[79j/NUCX2iGhIJXQ6s0HR4YnMChRPaY9BXJYFFenMCQA7GrkYkwaf2FmE+4mw6KU/COcXB6vDUZPUD58C4r7kc+UZ+s/58iQBTCq8eTWBeSOzJ1odK9JcGOsbf3CmL1ixJz9otayoN7smmxdXUErYcDaX2hqagKeAVyunfx6GU35JnGaZFjEWLG/kYtDaRbYB882fvU9QdE4Iie2mG26Nx1Rki7XPUkdKZsmPNVwYyCLQxpLUZiRwHl+X/cYAD0n/zwPrOQYCGdhtK3mBPVeefJRYW7Jt4u4o16IUSYQby7kHz19rGjEgGCoD+mfLj2mT0bRa/JKO/cnnykI6cDIypOjoQ5o37Ey3jQYQZOoCV6oDAmJUZQT0MQKv7cNbh0cqIr+gR2GfoKAtsrm8xJVOw3Zh1YCCyrDrdXUnsgv39x0kbwLRNEF6NFFyf+52dv1ocxJgQ6y/ZVRQz9m6sZ6jAodZxXDse2jf5pW6kzBSWn4aQFDgjCIZEXHz0OGSiqhr1xmWvywC5w5U2T2vNaPJAghuvzubakVbSa7HogDg11fVuq6IeF47JwFmm5vhFBJAe3y3Wuw7FMXPCNNdzVFk1i7veHVcW4PiFBzROMDLUUoC/BD3TSZwKr/lij4z8FqkxLws3EfIyxStg1LHZYCqMQSs3kRG8Oaxw1svoGV1V+D+SkpjPsMg3kHwcZJB8FcHZB5VzE9+tyJ78U/3WcsBH0goCO09zKXLaidNZqrD0ryhVj+DFxkLkb7R0dNkQVqXmOTk+OysmFbjp1urR41L8CrGXCbDLpLIuACSoKl05njHxRqHPExufe6SVN78OZ/AxHnCOXRVh4+hbz6f1UskXE8CC9keO4/ahBc+39v/fFeb/bTQBi01sFjTh2JD5XrqUgmHzxdjmZElMTz8HPPLV0e8WBmCPql4hNHw7Liv4D9pjoh87eLvNEw2SF9Wka63Wz/BqRev+3e9Ne5z7b3iYWub4rc3GYQfbhVyV1AHpSF4eKpROxP6tbxW6A7grM+gYzUdmMxR1aKOymwlsVQJg==]]></req_info></xml>"
  # Orders::Order.find('订单号').cancel_order()
  def wechat
    xml = request.body.string
    res = Hash.from_xml(xml)['xml']
    write_log_return({state: :notify_wechat, msg:'退款通知', desc: res})

    p '22222222222222222222222222', res
    respond_to do |f|
      f.xml {render xml: '<xml><return_code>SUCCESS</return_code><return_msg>OK</return_msg></xml>'}
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
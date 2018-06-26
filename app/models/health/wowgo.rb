#encoding: utf-8

require 'base64'
require 'rest-client'

#用户推送到高登的记录
class Health::Wowgo < ApplicationRecord
  self.table_name = 'health_wowgos' #向高登推送记录

  # 字段
  # api_code: 'new_user/update_user'
  # user_name: '用户账号'
  # gender: '性别'
  # height: '身高'时
  # birth: '出生日期'
  # headimgurl: '微信头像图片'
  # qrcode_text: '二维码字符串内容'
  # serialno: '更新编号'
  # userid: '返回的用户ID'
  # return_code: '返回code'
  # return_msg: '返回信息'
  validates_presence_of :user_name, message: '用户账号不能为空'
  validates_presence_of :gender,    message: '用户性别不能为空'
  validates_presence_of :height,    message: '用户身高不能为空'
  validates_presence_of :birth,     message: '用户生日不能为空'

  validates_inclusion_of :api_code, :in => %w{new_user update_user}, :message => '目前只支持创建用户和更新用户信息接口'

  before_save :startup

  def startup
    begin
      res         = execute
      return handle_success(res.body) if res.code.eql?(200)
      data        = callback_json(res.body)
      return_code = data['ErrCode']
      return_msg  = data['ErrMsg']
    rescue Exception => e
      return_code = 'error'
      return_msg  = "系统错误:#{e.message}"  
    end
  end

  private
  def callback_json(data)
    JSON.parse(data)
  end

  def handle_success(data)
    unless data.empty?
      data   = callback_json(data)
      userid = data['UserId']
    end
    return_msg  = '更新用户成功'
    return_code = 'succ'
  end

  def get_headimg_data
    data = ''
    begin
      data = RestClient.get(headimgurl).body
    rescue Exception => e
      Rails.logger.error("#{Time.now}--获取用户(#{user_name})头像数据报错: #{e.message}")
    end
    data.unpack('C*')
  end

  def qr_code
    qrcode = Health::QrCode.find_by(code: user_name)
    return qrcode if qrcode
    qr = Health::QrCode.new(code: user_name)
    return qr if qr.save
    raise '生成二维码错误'
  end

  def http_datas
    qrcode_text = qr_code.text
    data = {'UserName' => user_name, 'Gender' => gender, 'Height' => height, 
      'BirthDate' => birth, 'ProfilePhoto' => get_headimg_data}
    return data.merge({'QRCode_Wechat' => qrcode_text}) if api_code.eql?('new_user')
    data.merge({'Account' => user_name, 'SerialNo' => set.serialno})
  end

  def execute
    site = RestClient::Resource.new(base_set.addr)
    site[set.path].send(set.method, http_datas, headers)
  end

  # 接口认证头
  def headers
    {'Authorization' => base64_data, 'Host' => set.headers.host, 'Content-Type' => set.headers.content_type}
  end

  def base64_data
    code = Base64.encode64(base_set.username + ':' + base_set.password)
    'Basic ' + code
  end

  #读取配置
  def base_set
    Set::Wowgo
  end

  #api接口配置
  def set
    setting = base_set.actions.send(api_code) rescue nil
    raise "wowgo的health.yml没有配置相应的action-->#{api_code}" unless setting
    setting
  end
end
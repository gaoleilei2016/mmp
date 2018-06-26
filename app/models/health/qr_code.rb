#encoding: utf-8

require 'rqrcode'
require 'base64'

#用户推送到高登的个人二维码
class Health::QrCode < ApplicationRecord
  self.table_name = 'health_qrcodes'

  # code: '用户登录名'
  # img_data: '二维码数据-- varbinary'
  # text: '二维码内容'
  # img_type: 'png'
  # status: '状态'
  validates_presence_of :code, message: '用户login不能为空'

  before_save :create_image

  private
  def create_image
    text = qrcode_cont
    qr = RQRCode::QRCode.new(text)
    img_data = qr.as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: 360,
          border_modules: 4,
          module_px_size: 12,
          file: nil # path to write
          ).to_s
    img_type = 'png'
  end

  def qrcode_cont
    "#{set.qrcode_code}|#{login}|#{set.serialno}"
  end

  def set
    Set::Wowgo
  end
end
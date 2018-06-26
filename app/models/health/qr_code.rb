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
  validates_presence_of :code,     message: '用户login不能为空'
  validates_presence_of :img_data, message: '二维码数据不能为空'
  validates_presence_of :text,     message: '二维码内容不能为空'
  validates_presence_of :img_type, message: '二维码图片类型不能为空'

  class << self
    def create_qr_code(code)
      qr = new(args(code))
      return qr if qr.save
      raise qr.errors.full_messages.join(',')
    end

    private
    def args(code)
      text = qrcode_cont(code)
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
      {img_type: 'png', img_data: img_data, text: text, code: code}
    end

    def qrcode_cont(code)
      "#{set.qrcode_code}|#{code}|#{set.serialno}"
    end

    def set
      Set::Wowgo
    end
  end
end
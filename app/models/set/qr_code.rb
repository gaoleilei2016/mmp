#encoding: utf-8

require 'base64'
require 'rqrcode'

class Set::QrCode
  class << self
    def base64_data(data, length = 200, width = 200)
      qr = RQRCode::QRCode.new(data)
      png = qr.as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: 360,
          border_modules: 4,
          module_px_size: 12,
          file: nil # path to write
          )
      data = Base64.encode64(png.to_s)
      "data:image/png;base64,#{data}"
    end
  end
end
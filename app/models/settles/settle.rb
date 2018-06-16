class Settles::Settle < ApplicationRecord
	has_one :order,class_name:"::Orders::Order", foreign_key: 'settle_id'

# rails generate model Settles::Settle net_amt:float pay_method:string pay_type:string out_trade_no:string body:string detail:string device_info:string auth_code:string status:string

# CREATE TABLE Settle(
#  id INT NOT NULL AUTO_INCREMENT,
#  created_at DATETIME NOT NULL,
#  updated_at DATETIME NOT NULL,
#  order_code DATETIME NOT NULL,
#  net_amt DOUBLE NOT NULL,
#  pay_method VARCHAR(8) NOT NULL,
#  pay_type VARCHAR(8) NULL,
#  out_trade_no VARCHAR(32) NULL,
#  body VARCHAR(128) NULL,
#  detail VARCHAR(6000) NULL,
#  device_info VARCHAR(32) NULL,
#  auth_code VARCHAR(128) NULL,
#  status VARCHAR(4) NOT NULL,1已结算，2已退费
#  PRIMARY KEY ( id )
#  )ENGINE=InnoDB DEFAULT CHARSET=utf8;

	class << self
		def settle_save attrs = {}
			attrs = attrs.deep_symbolize_keys
			result = {ret_code:'0',info:''}
			order = ::Orders::Order.find(attrs[:order_id])
			return false if order.status != '1'
			case order.payment_type.to_s
			when '1'
				self.create(
					net_amt: attrs[:net_amt],
					pay_method: attrs[:pay_method],
					pay_type: attrs[:pay_type],
					out_trade_no: attrs[:out_trade_no],
					body: attrs[:body],
					detail: attrs[:detail],
					device_info: attrs[:device_info],
					auth_code: attrs[:auth_code],
					order_code: order.order_code
				)	
				order.update_attributes(:status,'2')
			when '2'

			when '3'
			when '4'
			end
		end
	end
end



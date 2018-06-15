class Settles::Settle < ApplicationRecord

# rails generate model Settles::Settle net_amt:float pay_method:string pay_type:string out_trade_no:string body:string detail:string device_info:string auth_code:string status:string

# CREATE TABLE Settle(
#  id INT NOT NULL AUTO_INCREMENT,
#  created_at DATETIME NOT NULL,
#  updated_at DATETIME NOT NULL,
#  net_amt DOUBLE NOT NULL,
#  pay_method VARCHAR(8) NOT NULL,
#  pay_type VARCHAR(8) NULL,
#  out_trade_no VARCHAR(32) NULL,
#  body VARCHAR(128) NULL,
#  detail VARCHAR(6000) NULL,
#  device_info VARCHAR(32) NULL,
#  auth_code VARCHAR(128) NULL,
#  status VARCHAR(4) NOT NULL,
#  PRIMARY KEY ( id )
#  )ENGINE=InnoDB DEFAULT CHARSET=utf8;

	class << self
		def settle_save
			
		end
	end
end

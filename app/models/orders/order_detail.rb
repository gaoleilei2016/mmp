class Orders::OrderDetail < ApplicationRecord
	belongs_to :order, class_name: '::Orders::Order', foreign_key: 'id', optional: true
	
	class << self
# CREATE TABLE order_detail(
#  id INT NOT NULL AUTO_INCREMENT,
#  created_at DATETIME NOT NULL COMMENT '创建时间',
#  updated_at DATETIME NOT NULL COMMENT '更新时间',
#  item_id varchar(32) NOT NULL COMMENT '商品id',
#  name varchar(32) NOT NULL COMMENT '商品名称',
#  order_id varchar(32) NOT NULL COMMENT '订单id',
#  quantity float(8) NOT NULL COMMENT '数量',
#  unit varchar(32) NULL COMMENT '单位',
#  specifications varchar(32) NULL COMMENT '规格',
#  dosage varchar(32) NULL COMMENT '剂型',
#  price float(32) NOT NULL COMMENT '单价',
#  net_amt float(32) NOT NULL COMMENT '总价',
#  prescript_id varchar(32) NOT NULL COMMENT '处方id',
#  firm varchar(32) NOT NULL COMMENT '厂商',
#  img_path varchar(6000) NULL COMMENT '图标',
#  PRIMARY KEY ( id )
#  )
		# rails generate model Orders::OrderDetail  item_id:string name:string order_id:string quantity:float unit:string specifications:string dosage:string price:float net_amt:float img_path:string
	end #内方法
end

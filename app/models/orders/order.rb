class Orders::Order < ApplicationRecord

# CREATE TABLE Order(
#  order_id INT NOT NULL AUTO_INCREMENT,
#  created_at DATETIME NOT NULL '创建时间',
#  updated_at DATETIME NOT NULL '更新时间',
#  payment_at DATETIME NOT NULL '支付时间',
#  end_time DATETIME NOT NULL '订单完成时间',
#  close_time DATETIME NOT NULL '订单关闭时间',
#  target_org_ii VARCHAR(32) NOT NULL '目标机构编码',
#  target_org_name VARCHAR(32) NOT NULL '目标机构名称',
#  source_org_ii VARCHAR(32) NOT NULL '来源机构编码',
#  source_org_name VARCHAR(32) NOT NULL '来源机构名称',
#  order_code VARCHAR(32) NOT NULL '订单号',
#  user_id VARCHAR(32) NOT NULL '用户id',
#  shipping_name varchar(20)  NULL '物流名称',
#  shipping_code varchar(20)  NULL '物流单号',
#  payment_type float NOT NULL '支付类型，1.在线支付，2.货到付款',
#  status VARCHAR(4) NOT NULL '未付款，已付款，未发货，已发货，交易成功，交易关闭',
#  PRIMARY KEY ( id )
#  )
	class << self
		#attrs = { target_org_ii:'目标药房的名称和机构', target_org_name:'目标药房的名称和机构', source_org_ii:'来源的医院名称和ii', source_org_name:'来源的医院名称和ii', order_code:'订单号', quantity:'数量',details:[name:'名称',item_id:'商品id',unit:'单位',quantity:'数量'，unit_price:'单价',specifications:'规格', dosage:'剂型']} 
		#订单生成创建
		def create_order attrs = {}
			attrs = attrs.deep_symbolize_keys
			order = self.create()

		end	

		private
		def get_order_code
			t = Time.now
			y = t.year.to_s[2,2]
			d = t.yday
			"#{y}#{d}#{t.object_id}"
		end
	end #内方法
end
 # target_org_ii:'目标药房的名称和机构', target_org_name:'目标药房的名称和机构', source_org_ii:'来源的医院名称和ii', source_org_name:'来源的医院名称和ii', order_code:'订单号', quantity:'数量', net_amt:'', status:'', title:'', describe:'',

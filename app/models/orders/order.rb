class Orders::Order < ApplicationRecord
	has_many :details, class_name: '::Orders::OrderDetail', foreign_key: 'order_id'
	has_many :medicals, class_name: '::Dict::Medication', foreign_key: 'order_id'
	has_many :prescriptions, class_name: '::Hospital::Prescription', foreign_key: 'order_id'
	
	# has_many :perscripts, class_name: '', foreign_key: 'order_id'
	# belongs_to :user, class_name: '::User', foreign_key: 'order_id'

# CREATE TABLE Order(
#  id INT NOT NULL AUTO_INCREMENT,
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
#  person_id varchar(32)  NULL 'personid',
#  doctor varchar(32)  NULL '开单医生',
#  shipping_name varchar(20)  NULL '物流名称',
#  shipping_code varchar(20)  NULL '物流单号',
#  shipping_code varchar(20)  NULL '物流单号',
#  payment_type float NOT NULL '支付类型,1.在线支付,2.货到付款',
#  status VARCHAR(4) NOT NULL '未付款,已付款,未发货,已发货,交易成功,交易关闭',
#  PRIMARY KEY ( id )
#  )

# rails generate model Orders::Order payment_at:time end_time:time close_time:time target_org_ii:string target_org_name:string source_org_ii:string source_org_name:string order_code:string user_id:string shipping_name:string shipping_code:string payment_type:float status:string
	#订单金额
	def net_amt
		details.sum(:net_amt)
	end

	class << self
		#attrs = { target_org_ii:'目标药房的名称和机构', target_org_name:'目标药房的名称和机构', source_org_ii:'来源的医院名称和ii', source_org_name:'来源的医院名称和ii', order_code:'订单号',perscript_id:'处方id', user_id:'用户id',details:[name:'名称',item_id:'商品id',unit:'2',quantity:'1',price:'单价',specifications:'规格', dosage:'剂型']} 
		#订单生成创建（一个订单内容对应一张处方）
		# def create_order(attrs = {})
		# 	attrs = attrs.deep_symbolize_keys
		# 	# order_code = get_order_code
		# 	order = self.create(
		# 		 target_org_ii: attrs[:target_org_ii],
		# 		 target_org_name: attrs[:target_org_name],
		# 		 source_org_ii: attrs[:source_org_ii],
		# 		 source_org_name: attrs[:source_org_name],
		# 		 order_code: order_code,
		# 		 doctor: attrs[:doctor],
		# 		 user_id: attrs[:user_id],
		# 		 user_id: attrs[:person_id],
		# 		 status: 'N'
		#  		)
		# 	# Relation::OrdersAndPrescription.create(prescript_id:attrs[:prescript_id] ,order_id:order.id.to_s)
		# 	attrs[:details].each do |detail|
		# 		net_amt = (detail[:quantity].to_f * detail[:price].to_f).round(2)
		# 		order.details << ::Orders::OrderDetail.create(detail.merge({net_amt:net_amt}))
		# 	end
		# 	order.save
		# 	order
		# end	

		#获取订单生成数据
		def create_order_by_presc_ids(ids = [])
			##通过处方拿到订单生成数据
			prescs = ::Hospital::Interface.prescription_to_order(ids)
			attrs = prescs.first.last
			order = self.create(
			 target_org_ii: attrs[:target_org_ii].to_s,
			 target_org_name: attrs[:target_org_name].to_s,
			 source_org_ii: attrs[:source_org_ii].to_s,
			 source_org_name: attrs[:source_org_name].to_s,
			 order_code: get_order_code,
			 doctor: attrs[:doctor].to_s,
			 user_id: attrs[:user_id].to_s,
			 person_id: attrs[:person_id].to_s,
			 status: 'N'
	 		)
			prescs.each do |k,v|
				order.prescriptions << ::Hospital::Prescription.find(k)
				v[:details].each do |detail|
					net_amt = (detail[:quantity].to_f * detail[:price].to_f).round(2)
					order.details << Orders::OrderDetail.create(detail.merge({net_amt:net_amt}))
				end
			end
			order.save
			order
		end
		#更新订单信息
		def update_order(attrs = {})
			attrs = attrs.deep_symbolize_keys
			order = self.where(:order_code=>attrs.delete(:order_code).to_s).last||self.where(:id=>attrs.delete(:order_id).to_s).last
			return {ret_code:'-1',info:'未找到需要更新的处方信息！'} unless order
			order.update_attributes(attrs)
			{ret_code:'0',info:'更新成功'} 
		end
		#更新订单明细信息
		def update_order_detail(attrs = {})
			attrs = attrs.deep_symbolize_keys
			detail = self.where(:id=>attrs.delete(:detail_id).to_s).last
			return {ret_code:'-1',info:'未找到需要更新的处方信息！'} unless detail
			detail.update_attributes(attrs)
			{ret_code:'0',info:'更新成功'} 
		end

		#作废订单明细
		def remove_order_detail(attrs = {})
			attrs = attrs.deep_symbolize_keys
			detail = ::Orders::OrderDetail.where(:id=>attrs.delete(:detail_id).to_s).last
			detail.order.update_attributes("status"=>'C')
		end
		private
		##获取订单号，私有调用
		def get_order_code
			t = Time.now
			y = t.year.to_s[2,2]
			d = t.yday
			code = "#{y}#{d}#{t.object_id}"
			while Orders::Order.where("order_code = ? AND created_at < ?",code,t.beginning_of_day).last
				code = get_order_code
			end
			code
		end
	end #内方法
end

class Orders::Order < ApplicationRecord
	has_many :details, class_name: '::Orders::OrderDetail', foreign_key: 'order_id'
	has_many :medicals, class_name: '::Dict::Medication', foreign_key: 'order_id'
	has_many :prescriptions, class_name: '::Hospital::Prescription', foreign_key: 'order_id'
	belongs_to :settle,class_name: "::Settles::Settle",foreign_key: 'order_id'
	
	# has_many :perscripts, class_name: '', foreign_key: 'order_id'
	# belongs_to :user, class_name: '::User', foreign_key: 'order_id'

# CREATE TABLE Order(
#  id INT NOT NULL AUTO_INCREMENT,
#  created_at DATETIME NOT NULL '创建时间',
#  updated_at DATETIME NOT NULL '更新时间',
#  payment_at DATETIME NOT NULL '支付时间',
#  end_time DATETIME NOT NULL '订单完成时间',
#  close_time DATETIME NOT NULL '订单关闭时间',
#  target_org_id VARCHAR(32) NOT NULL '目标机构编码',
#  target_org_name VARCHAR(32) NOT NULL '目标机构名称',
#  source_org_id VARCHAR(32) NOT NULL '来源机构编码',
#  source_org_name VARCHAR(32) NOT NULL '来源机构名称',
#  order_code VARCHAR(32) NOT NULL '订单号',
#  user_id VARCHAR(32) NOT NULL '用户id',
#  person_id varchar(32)  NULL 'personid',
#  doctor varchar(32)  NULL '开单医生',
#  patient_name varchar(20)  NULL '患者名字',
#  patient_phone varchar(20)  NULL '患者电话号码',
#  shipping_name varchar(20)  NULL '物流名称',
#  shipping_code varchar(20)  NULL '物流单号',
#  payment_type float NOT NULL '支付类型,1.在线支付,2.线下支付',
#  status VARCHAR(4) NOT NULL '1未付款,2已付款,3未发货,4已发货,5交易成功,6交易关闭',
#  PRIMARY KEY ( id )
#  )

# rails generate model Orders::Order payment_at:time end_time:time close_time:time target_org_id:string target_org_name:string source_org_id:string source_org_name:string order_code:string user_id:string shipping_name:string shipping_code:string payment_type:float status:string
	#订单金额
	def net_amt
		details.sum(:net_amt)
	end

	class << self
		#attrs = { target_org_id:'目标药房的名称和机构', target_org_name:'目标药房的名称和机构', source_org_id:'来源的医院名称和ii', source_org_name:'来源的医院名称和ii', order_code:'订单号',perscript_id:'处方id', user_id:'用户id',details:[name:'名称',item_id:'商品id',unit:'2',quantity:'1',price:'单价',specifications:'规格', dosage:'剂型']} 
		#订单生成创建（一个订单内容对应一张处方）
		# def create_order(attrs = {})
		# 	attrs = attrs.deep_symbolize_keys
		# 	# order_code = get_order_code
		# 	order = self.create(
		# 		 target_org_id: attrs[:target_org_id],
		# 		 target_org_name: attrs[:target_org_name],
		# 		 source_org_id: attrs[:source_org_id],
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

# hospital_id:'医院id'
# hospital_name:'医院名字'
# doctor:'医院医生名字'
# user_id:'user_id'
# person_id:'person_id'
# person_id:'患者名字'
# details:{id:{details}}#处方id   处方明细



# {:details=>{16=>[{:name=>"心胃止痛胶囊", :item_id=>500, :unit=>"盒", :quantity=>1.0, :price=>43.0, :specifications=>"0.25gx48s", :dosage=>"剂型"}], 17=>[{:name=>"对乙酰氨基酚混悬滴剂（泰诺林）", :item_id=>388, :unit=>"瓶", :quantity=>1.0, :price=>11.0, :specifications=>"15ml", :dosage=>"剂型"}, {:name=>"乳酸钠林格注射液（直立代）", :item_id=>164, :unit=>"袋", :quantity=>1.0, :price=>4.0, :specifications=>"500ml", :dosage=>"剂型"}]}, 

# :hospital_id=>33, :hospital_name=>"第一个医院", :doctor=>"cg1", :user_id=>nil, :person_id=>13, :person_name=>"陈刚", :phone=>"18585075312"} 



		#获取订单生成数据
		def create_order_by_presc_ids(attrs = {})
			attrs = attrs.deep_symbolize_keys
			return false if attrs[:pharmacy_id].blank?
			return false if attrs[:pharmacy_name].blank?
			return false if attrs[:prescription_ids].blank?
			##通过处方拿到订单生成数据
			presc = ::Hospital::Interface.prescription_to_order2(attrs[:prescription_ids])
			order = self.create(
			 target_org_id: attrs[:pharmacy_id].to_s,
			 target_org_name: attrs[:pharmacy_name].to_s,
			 source_org_id: presc[:hospital_id].to_s,
			 source_org_name: presc[:hospital_name].to_s,
			 patient_name: presc[:person_name].to_s,
			 patient_phone: presc[:phone].to_s,
			 order_code: get_order_code,
			 doctor: presc[:doctor].to_s,
			 user_id: presc[:user_id].to_s,
			 person_id: presc[:person_id].to_s,
			 status: '1'
	 		)
			presc[:details].each do |k,details|
				order.prescriptions << ::Hospital::Prescription.find(k)
				details.each do |detail|
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
		#订单明细显示
		def get_order_details(attrs={})
			attrs = attrs.deep_symbolize_keys
			result = {ret_code:'0',info:'',prescriptions:[]}
			::Orders::Order.where("user_id = ? and status = ?",attrs[:person_id],attrs[:status]||'1').each do |order|
				result[:prescriptions] << {
					order_code: order.order_code,
					amt: order.net_amt,
					status: order.status,
					payment_at: order.payment_at,
					end_time: order.end_time,
					close_time: order.close_time,
					target_org_name: order.target_org_name,
					source_org_name: order.source_org_name,
					patient_phone: order.patient_phone,
					doctor: order.doctor,
					payment_type: order.payment_type,
					details: order.details.map{|x| {
									name: x.name,
									quantity: x.quantity,
									unit: x.unit,
									specifications: x.specifications,
									dosage: x.dosage,
									price: x.price,
									net_amt: x.net_amt,
									img_path: x.img_path
								}
							}
				}
			end
			result
		end

		#订单完成（药房调用）
		def order_completion

		end

		#订单状态消息发送推送
		def send_order_message
			
		end

		#药房查询 attrs = {type:'1/2',order_code:'',org_id:''}
		def get_order_to_medical attrs = {}
			attrs = attrs.deep_symbolize_keys
			return [] if attrs[:org_id].blank?
			condtion = "target_org_id = #{attrs[:org_id]} "
			if attrs[:order_code].present?
				condtion.concat("order_code = #{attrs[:order_code]}")
			else
			# condtion = "(payment_type = 1 and status = 2 ) or (payment_type = 2)"
				case  attrs[:type].to_s
				when '1'#未付款
					condtion.concat(" and payment_type = 1 and status = 2")
				when '2'#已付款
					condtion.concat(" and payment_type = 2")
				else#否则查看全部
				end
			end
			Orders::Order.where(condtion).map{|order|  
				{
					order_code: order.order_code,
					amt: order.net_amt,
					status: order.status,
					payment_at: order.payment_at,
					end_time: order.end_time,
					close_time: order.close_time,
					target_org_name: order.target_org_name,
					source_org_name: order.source_org_name,
					doctor: order.doctor,
					prescriptions_id: order.prescription_ids,
					patient_name: order.patient_name,
					patient_phone: order.patient_phone,
					payment_type: order.payment_type,
					details: order.details.map{|x| {
									name: x.name,
									quantity: x.quantity,
									unit: x.unit,
									specifications: x.specifications,
									dosage: x.dosage,
									price: x.price,
									net_amt: x.net_amt,
									img_path: x.img_path
								}
							}
				}  
			}
		end

		private
		##获取订单号，私有调用
		def get_order_code
			t = Time.now
			y = t.year.to_s[2,2]
			d = t.yday
			code = "D#{y}#{d}#{t.object_id}"
			while Orders::Order.where("order_code = ? AND created_at < ?",code,t.beginning_of_day).last
				code = get_order_code
			end
			code
		end
	end #内方法
end



class Orders::Order < ApplicationRecord
	has_many :details, class_name: '::Orders::OrderDetail', foreign_key: 'order_id'
	has_many :medicals, class_name: '::Dict::Medication', foreign_key: 'order_id'
	has_many :prescriptions, class_name: '::Hospital::Prescription', foreign_key: 'order_id'
	belongs_to :settle,class_name: "::Settles::Settle",foreign_key: 'settle_id' , optional: true
	
	# has_many :perscripts, class_name: '', foreign_key: 'order_id'
	# belongs_to :user, class_name: '::User', foreign_key: 'order_id'

# CREATE TABLE Order(
#  id INT NOT NULL AUTO_INCREMENT,
#  extension  varchar(32) not null "订单前缀"
#  created_at DATETIME NOT NULL '创建时间',
#  updated_at DATETIME NOT NULL '更新时间',
#  payment_at DATETIME NOT NULL '支付时间',
#  drug_user varchar(20)  NULL '发药人',
#  drug_user_id varchar(20)  NULL '发药人',
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
#  patient_sex varchar(20)  NULL '性别',
#  patient_age varchar(20)  NULL '年龄',
#  patient_iden varchar(20)  NULL '身份证',
#  patient_phone varchar(20)  NULL '患者电话号码',
#  shipping_name varchar(20)  NULL '物流名称',
#  shipping_code varchar(20)  NULL '物流单号',
#  pay_type float NOT NULL '支付类型,1.微信,2.支付宝',
#  payment_type float NOT NULL '支付类型,1.在线支付,2.线下支付',
#  status VARCHAR(4) NOT NULL '1未付款,2已付款,3未发货,4已发货,5交易成功,6交易关闭,7交易取消',
#  PRIMARY KEY ( id )
#  )

# rails generate model Orders::Order payment_at:time end_time:time close_time:time target_org_id:string target_org_name:string source_org_id:string source_org_name:string order_code:string user_id:string shipping_name:string shipping_code:string payment_type:float status:string
	#订单金额
	def net_amt
		details.sum(:net_amt)
	end
	#药房
	def pharmacy
		::Admin::Organization.find(target_org_id) rescue nil
	end
	#医院
	def pharmacy
		::Admin::Organization.find(source_org_id) rescue nil
	end

	#取消订单 Orders::Order.find(id).cancel_order()
	def cancel_order
		# ['']
		update_attributes(status:'7')
		prescriptions.each{|x| x.order = nil;x.save}
		{ret_code:'0',info:'订单已取消。'}
	end

	#订单超时自动关闭
	def close_order
		update_attributes(status:'6',close_time:Time.now.to_s(:db))
		prescriptions.each{|x| x.order = nil;x.save}
		{ret_code:'0',info:'订单已超时，自动关闭。'}
	end

	#订单结算  Orders::Order.find(id).order_settle(1.微信,2.支付宝')
	def order_settle pay_type = '1'
		update_attributes(pay_type:pay_type,status:'2',payment_at:Time.now.to_s(:db))
		{ret_code:'0',info:'订单结算成功！'}
	end

	class << self
			

# hospital_id:'医院id'
# hospital_name:'医院名字'
# doctor:'医院医生名字'
# user_id:'user_id'
# person_id:'person_id'
# person_id:'患者名字'
# details:{id:{details}}#处方id   处方明细



# {:details=>{16=>[{:name=>"心胃止痛胶囊", :item_id=>500, :unit=>"盒", :quantity=>1.0, :price=>43.0, :specifications=>"0.25gx48s", :dosage=>"剂型"}], 17=>[{:name=>"对乙酰氨基酚混悬滴剂（泰诺林）", :item_id=>388, :unit=>"瓶", :quantity=>1.0, :price=>11.0, :specifications=>"15ml", :dosage=>"剂型"}, {:name=>"乳酸钠林格注射液（直立代）", :item_id=>164, :unit=>"袋", :quantity=>1.0, :price=>4.0, :specifications=>"500ml", :dosage=>"剂型"}]}, 

# :hospital_id=>33, :hospital_name=>"第一个医院", :doctor=>"cg1", :user_id=>nil, :person_id=>13, :person_name=>"陈刚", :phone=>"18585075312"} 



		#获取处方生成订单数据
		def create_order_by_presc_ids(attrs = {})
			attrs = attrs.deep_symbolize_keys
			result = {ret_code:'0',info:'',order:nil}
			if attrs[:pharmacy_id].blank?
				result[:ret_code] = '-1'
				result[:info].concat("药房ID不能为空!")
			end
			if attrs[:pharmacy_name].blank?
				result[:ret_code] = '-1'
				result[:info].concat("药房名称不能为空！")
			end
			if attrs[:prescription_ids].blank?
				result[:ret_code] = '-1'
				result[:info].concat("处方ID不能为空!")
			end
			if attrs[:prescription_ids].blank?
				result[:ret_code] = '-1'
				result[:info].concat("处方ID不能为空!")
			end
			if attrs[:payment_type].blank?
				result[:ret_code] = '-1'
				result[:info].concat("支付类别不能为空!")
			end
			if ::Hospital::Prescription.where("id in (?)",attrs[:prescription_ids]).select{|x|x.order}.present?
				result[:ret_code] = '-1'
				result[:info].concat("处方包含有效订单，无法继续生成!")
			end
			if result[:ret_code].to_s == '0'
			##通过处方拿到订单生成数据
				presc = ::Hospital::Interface.prescription_to_order2(attrs[:prescription_ids])
				# Orders::Order.where("prescription_id in (?)",attrs[:prescription_ids].join(',')).count
				order = self.create(
				 target_org_id: attrs[:pharmacy_id].to_s,
				 target_org_name: attrs[:pharmacy_name].to_s,
				 user_id: attrs[:user_id].to_s,
				 payment_type: attrs[:payment_type] == 'online' ? 1 : 2,
				 source_org_id: presc[:hospital_id].to_s,
				 patient_sex: presc[:patient_sex].to_s,
				 patient_age: presc[:patient_age].to_s,
				 patient_iden: presc[:patient_iden].to_s,
				 source_org_name: presc[:hospital_name].to_s,
				 patient_name: presc[:person_name].to_s,
				 patient_phone: presc[:phone].to_s,
				 order_code: get_order_code(presc[:hospital_id].to_s),
				 doctor: presc[:doctor].to_s,
				 person_id: presc[:person_id].to_s,
				 status: '1'
		 		)
				presc[:details].each do |k,details|
					prescription = ::Hospital::Prescription.find(k)
					order.prescriptions << prescription
					prescription.order = order
					prescription.save
					details.each do |detail|
						net_amt = (detail[:quantity].to_f * detail[:price].to_f).round(2)
						order.details << Orders::OrderDetail.create(detail.merge({net_amt:net_amt}))
					end
				end
				order.save
				result[:info].concat("订单生成成功！请在#{(Time.now + 1.minutes).to_s(:db)}之前完成订单支付")
				result[:order] = order
				if attrs[:payment_type] == 'online'
					sch = ::Scheduler.new()
					sch.timer_at(Time.now + 1.minutes,"::Orders::Order.cancel_order({id:#{order.id.to_s}})")
				end
			end
			result
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

		#取消订单(自动或者手动)
		def cancel_order(attrs = {})
			attrs = attrs.deep_symbolize_keys
			order = self.where(:id=>attrs[:id]).last
			if order.status.to_s == '1'
				order.update_attributes(status:'6',close_time:Time.now.to_s(:db))
			end
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
									firm: x.firm,
									img_path: x.img_path
								}
							}
				}
			end
			result
		end

		#订单完成（药房调用） attrs = {id:'订单id',drug_user:'发药人',drug_user_id:'发药人id'}
		def order_completion attrs = {}
			attrs = attrs.deep_symbolize_keys
			result = {ret_code:'0',info:''}
			if attrs[:id].blank?
				result[:ret_code] = '-1'
				result[:info].concat("发药人不能为空!")
			end
			if attrs[:drug_user].blank?
				result[:ret_code] = '-1'
				result[:info].concat("发药人id不能为空！")
			end
			if attrs[:drug_user_id].blank?
				result[:ret_code] = '-1'
				result[:info].concat("订单ID不能为空!")
			end
			unless order = Orders::Order.where("id = ? and status in (1,2)",attrs[:id])
				result[:ret_code] = '-1'
				result[:info].concat("当前订单状态异常!")	
			end
			if result[:ret_code].to_s == '-1'
				order.update_attributes(drug_user:attrs[:drug_user],
										drug_user_id:attrs[:drug_user_id],
										end_time:Time.now,
										status:attrs[:status],
										)
				result[:info] = "订单已完成。" 
				##更新处方状态。。。。。。
			end
			result

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
					id: order.id,
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
									firm: x.firm,
									img_path: x.img_path
								}
							}
				}  
			}
		end

		# private
		##获取订单号，私有调用
		def get_order_code source_org_id
			t = Time.now.beginning_of_day
			y = t.year.to_s[2,2]
			d = ("00" + t.yday.to_s)[-3,3]
			ser = ("000" + Orders::Order.where("source_org_id = ? AND created_at > ?",source_org_id,t).count.to_s)[-4,4]
			"#{y}#{d}#{ser}"
			# while Orders::Order.where("order_code = ? AND created_at < ?",code,t.beginning_of_day).last
			# 	code = get_order_code
			# end
			# {extension:'',code:''}
			# code
		end
	end #内方法
end



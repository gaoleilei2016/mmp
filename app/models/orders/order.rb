class Orders::Order < ApplicationRecord
	table_name = "Orders_order"
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
#  drug_user_id varchar(20)  NULL '发药人id',
#  end_time DATETIME NOT NULL '订单完成时间',
#  close_time DATETIME NOT NULL '订单关闭时间',
#  refund_medical_time DATETIME NOT NULL '退药时间',
#  target_org_id VARCHAR(32) NOT NULL '目标机构编码',
#  target_org_name VARCHAR(32) NOT NULL '目标机构名称',
#  source_org_id VARCHAR(32) NOT NULL '来源机构编码',
#  source_org_name VARCHAR(32) NOT NULL '来源机构名称',
#  order_code VARCHAR(32) NOT NULL '订单号',
#  user_id VARCHAR(32) NOT NULL '用户id',
#  reason VARCHAR(32) NOT NULL '原因',
#  is_send_medical int NOT NULL '是否发过药',
#  person_id varchar(32)  NULL 'personid',
#  doctor varchar(32)  NULL '开单医生',
#  patient_name varchar(20)  NULL '患者名字',
#  patient_sex varchar(20)  NULL '性别',
#  patient_age varchar(20)  NULL '年龄',
#  patient_iden varchar(20)  NULL '身份证',
#  patient_phone varchar(20)  NULL '患者电话号码',
#  shipping_name varchar(20)  NULL '物流名称',
#  shipping_code varchar(20)  NULL '物流单号',
#  pay_type float NOT NULL '支付类型,Alipay ,Wechat',
#  payment_type float NOT NULL '支付类别,1.在线支付,2.线下支付',
#  status VARCHAR(4) NOT NULL '1待付款,2已收费,3未发货,4已发货,5交易完成,6已退药,7交易关闭'#未付款的取消叫做交易关闭，已付款的取消就是交易取消,
#  PRIMARY KEY ( id )
#  )

# rails generate model Orders::Order payment_at:time end_time:time close_time:time target_org_id:string target_org_name:string source_org_id:string source_org_name:string order_code:string user_id:string shipping_name:string shipping_code:string payment_type:float status:string
	#订单金额
	def net_amt
		details.sum(:net_amt).to_f.round(2)
	end
	#药房
	def pharmacy
		::Admin::Organization.find(target_org_id) rescue nil
	end
	#医院
	def pharmacy
		::Admin::Organization.find(source_org_id) rescue nil
	end

	#取消订单（线上使用）Orders::Order.find(id).cancel_order(cur_user)(手自一体)
	def cancel_order(cur_user=nil,reason='')
		current_user = current_user||User.find(user_id)
		result = {ret_code:'-1',info:'当前订单不允许取消'} 
		return result if _locked.to_i == 1
		begin
			update_attributes(_locked:1)
			::Orders::Order.transaction do
				case status.to_s
				when '1'
					if !cur_user && payment_type.to_s == '1' && (created_at+30.minutes) > Time.now
						sch = ::Scheduler.new()
						sch.timer_at(created_at + 30.minutes,"::Orders::Order.find(#{order.id.to_s}).cancel_order({},'超时关闭')")
						return {ret_code:'-1',info:'订单未超时'}
					end
					# prescriptions.each{|x|x.back_wait_charge({}, current_user)}#待收费转为已审核
					update_attributes(status:'7',close_time:Time.now.to_s(:db),reason:reason)
					# prescriptions.each{|x|x.cancel_bill({}, current_user)}
					::Orders::Order.cancel_bill(self.prescriptions,{},cur_user)#取消订单回调处方
					result = {ret_code:'0',info:'订单已取消。'}
				when payment_type.to_s == '1' && cur_user && '2'#线上已结算的可以取消
					# ::Orders::Order.cancel_bill(prescriptions,{},cur_user)#取消订单回调处方

					# prescriptions.each{|x|x.cancel_bill({}, current_user)}
					update_attributes(status:'7',end_time:Time.now.to_s(:db),reason:reason)
					data = {
						ch:target_org_id,#药房id
						org_id:target_org_id,#药房id
						status:status, #订单状态
						order_id:id, #订单id
						created_at:created_at.strftime("%Y-%m-%d %H:%M"), #订单创建时间
						order_code:order_code, #订单号
						patient_name:patient_name, #患者名字
						amt:net_amt, #订单金额
						flag:false, #true已收费  false 退费
						info:'您有一张订单结算被用户取消了！', #订单金额
					}
					# {ch:’’,type:’’,event:’’,content:’’}
					::NoticeChannel.publish(data) rescue nil
					# ::NoticeBroadcastJob.perform_later(data:data)
					# ::Orders::Order.cancel_bill(self.prescriptions,{},cur_user) if is_send_medical.to_i<=0#取消订单回调处方
					result = {ret_code:'0',info:'取消成功。'}
				when '5'
					result = {ret_code:'-1',info:'订单已完成，不允许取消。'}
				when '6'
					# prescriptions.each{|x|x.back_wait_charge({}, current_user)}
					# ::Orders::Order.cancel_bill(self.prescriptions,cur_user)#取消订单回调处方
					update_attributes(status:'7',close_time:Time.now.to_s(:db),reason:reason)
					result = {ret_code:'0',info:'订单已取消。'}
					# return {ret_code:'-1',info:'订单已关闭，不允许取消。'}
				when '7'
					result = {ret_code:'-1',info:'订单已取消，不允许再次取消。'}
				end
			end
		rescue Exception => e
			p e.backtrace
			p '我的，都是我的！'
			result = {ret_code:'-1',info:'订单取消异常!'}
		ensure
			self.update_attributes(_locked:0)
		end
		result
	end

	
	##退药退费方法（药店使用） attrs = {reason:'',current_user:''}
	def cancel_medical(attrs={})
		attrs = attrs.deep_symbolize_keys
		result = {ret_code:'-1',info:'当前状态不需要退药。',amt:0.0}
		begin
			update_attributes(_locked:1)
			case status.to_s
			when '1'

			when '2'#已收费
				::Orders::Order.transaction do
					if is_send_medical.to_i>0#是否发过药
						update_attributes(status:'7',end_time:Time.now.to_s(:db),reason:'药房退款')
						# ::Orders::Order.cancel_prescriptions(self.prescriptions,attrs[:current_user])#线下的处方废弃
					else
						update_attributes(status:'1')
						# ::Orders::Order.cancel_bill(self.prescriptions,cur_user) #if is_send_medical.to_i>0#处方回到已审核
					end
				end
				result = {ret_code:'0',info:'退费成功'}
			when '3'

			when '4'

			when '5'#完成
				::Orders::Order.transaction do
					update_attributes(status:'2',refund_medical_time:Time.now.to_s(:db),reason:"退药成功",refund_medical_reason:attrs[:reason])
					# cancel_order_by_private(prescriptions,attrs[:current_user],attrs[:reason])
					if self.payment_type.to_s == '2' #如果是线下支付的
						# ::Orders::Order.cancel_bill(self.prescriptions,attrs[:current_user])#处方回到已审核
						update_attributes(status:'7',close_time:Time.now.to_s(:db),reason:"退药成功",refund_medical_reason:attrs[:reason])
						# ::Orders::Order.cancel_prescriptions(self.prescriptions,attrs[:current_user])#线下的处方废弃
					end
					
				end
				result[:ret_code] = '0'
				result[:info] = '退药成功！'
			when '6'

			when '7'

			else

			end
		rescue Exception => e
			p e.backtrace
			p '我的，都是我的！'
			result = {ret_code:'-1',info:'退药异常。',amt:0.0}
		ensure
			update_attributes(_locked:0)
		end
		result
	end



	# private
	def cancel_order_by_private(prescriptions,cur_user,reason)
		arg = {
		# 退费人
			return_charge_opt: {
				id: cur_user&.id.to_s,
				display: cur_user&.name.to_s
			},
			# 退费时间
			return_charge_at: Time.now.to_s(:db)
		}
		prescriptions.each{|x|x.return_charge(arg, cur_user)}
	end

	# #订单超时自动关闭
	# def close_order
	# 	update_attributes(status:'6',close_time:Time.now.to_s(:db))
	# 	prescriptions.each{|x| x.bill_id = '';x.order = nil;x.save}
	# 	{ret_code:'0',info:'订单已超时，自动关闭。'}
	# end

	#订单结算  Orders::Order.find(id).order_settle(1.微信,2.支付宝')
	def order_settle(pay_type,cur_user=nil)
		result = {ret_code:'0',info:''}
		cur_user ||= User.find(user_id)
		# case pay_type.to_s
		# when "Alipay"
		# 	Pay::Order.find_by(out_trade_no: "#{source_org_id}#{order_code}")&.paid? || (return {ret_code:'-1',info:'未查询到已支付信息，请确认！'})
		# when "Wechat" #查询微信订单是否支付成功
		# 	Pay::Order.find_by(out_trade_no: "#{source_org_id}#{order_code}")&.paid? || (return {ret_code:'-1',info:'未查询到已支付信息，请确认！'})
		# end
		return {ret_code:'-1',info:'当前订单状态异常，不允许结算。'}if status.to_s != '1'
		begin
			::Orders::Order.transaction do 
				# args = {
				# 	# 创建订单人
				# 	charger: {
				# 		id: cur_user.id,
				# 		display: cur_user.name
				# 		},
				# 	# 订单创建时间
				# 	charge_at: created_at.to_s(:db)
				# }
				# ##通知处方订单已结算
			 # 	prescriptions.each{|x|x.charged(args, cur_user)}
				update_attributes(pay_type:pay_type,status:'2',payment_at:Time.now.to_s(:db))
				data = {
							ch:target_org_id,#药房id
							org_id:target_org_id,#药房id
							status:status, #订单状态
							order_id:id, #订单id
							created_at:created_at.strftime("%Y-%m-%d %H:%M"), #订单创建时间
							order_code:order_code, #订单号
							patient_name:patient_name, #患者名字
							amt:net_amt, #订单金额
							flag:true, #true已收费  false 退费
							info:'您有新的已结算订单！', #订单金额
						}
				::NoticeChannel.publish(data) rescue nil
				# ::NoticeBroadcastJob.perform_later(data:data)
			end
			rsult = {ret_code:'0',info:'订单结算成功！'}
		rescue Exception => e
			p e.backtrace
			rsult = {ret_code:'-1',info:'订单结算异常！'}
		end
		result
	end

	class << self
		#取消订单时回调处方
		def cancel_bill(pres,current_user)
			arg = {}
			pres.each{|x|x.cancel_bill(arg, current_user)}
		end
		#废弃处方 退款时
		def cancel_prescriptions(pres,current_user)
			arg = {
					# 废弃人
					abandonor: {
						id: current_user&.id,
						display: current_user&.name
					},
					# 废弃时间
					abandon_at: Time.now
				}
			pres.each{|x|x.abandon(arg, current_user);x.bill_id = '';x.bill = nil;x.save}
		end
		#检查订单定时器
		def check_order_timer
			Orders::Order.where('payment_type = 1 and status = 1 and created_at > ?' ,Time.now - 28.minutes ).update_all(status:'7',reason:'超时关闭')
			Orders::Order.where('payment_type = 1 and status = 1 and created_at < ?' ,Time.now - 30.minutes ).each{|x| 
				sch = ::Scheduler.new();
				sch.timer_at(Time.now + (30.minutes - (Time.now - x.created_at)),"::Orders::Order.find(#{x.id.to_s}).cancel_order({},'超时关闭')")}
		end
			

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
			if ::Hospital::Prescription.where("id in (?)",attrs[:prescription_ids]).select{|x|x.bill}.present?
				result[:ret_code] = '-1'
				result[:info].concat("处方包含有效订单，无法继续生成!")
			end
			if ::Hospital::Prescription.where("status = 0 and id in (?)",attrs[:prescription_ids]).present?
				result[:ret_code] = '-1'
				result[:info].concat("处方未审核!待医院审核完成后即可生成领药订单。")
			end
			if result[:ret_code].to_s == '0'
				begin
					::Orders::Order.transaction do 
					##通过处方拿到订单生成数据
						presc = ::Hospital::Interface.prescription_to_order2(attrs[:prescription_ids])
						# Orders::Order.where("prescription_id in (?)",attrs[:prescription_ids].join(',')).count
						order = self.create(
						 target_org_id: attrs[:pharmacy_id].to_s,
						 target_org_name: attrs[:pharmacy_name].to_s,
						 user_id: attrs[:current_user].id.to_s,
						 invoice_id: attrs[:invoice_id].to_s,
						 _locked: 0,
						 settle_times: 0,
						 payment_type: attrs[:payment_type].to_s == 'online' ? '1' : '2',
						 source_org_id: presc[:hospital_id].to_s,
						 patient_sex: presc[:patient_sex].to_s,
						 patient_age: presc[:patient_age].to_s,
						 patient_iden: presc[:patient_iden].to_s,
						 source_org_name: presc[:hospital_name].to_s,
						 patient_name: presc[:person_name].to_s,
						 patient_phone: presc[:phone].to_s,
						 order_code: get_order_code(attrs[:pharmacy_id].to_s),
						 doctor: presc[:doctor].to_s,
						 person_id: presc[:person_id].to_s,
						 status: attrs[:status]||'1'
				 		)
				 		#通知处方的数据
				 		args = {
							# 创建订单人
							create_bill_opt: {
								id: attrs[:current_user].id.to_s,
								display: attrs[:current_user].name.to_s,
							},
							# 订单创建时间
							bill_at: order.created_at.to_s(:db),
						  	bill_id: order.id,
						}
						presc[:details].each do |k,details|
							prescription = ::Hospital::Prescription.find(k)
							order.prescriptions << prescription
							prescription.bill = order
							prescription.save
							prescription.commit_bill(args, attrs[:current_user])#改变处方为完成
							details.each do |detail|
								net_amt = (detail[:quantity].to_f * detail[:price].to_f).round(2)
								order.details << Orders::OrderDetail.create(detail.merge({net_amt:net_amt,prescription_id:k}))
							end
						end
						order.save
						result[:info].concat("订单生成成功！")
						result[:order] = order
						if attrs[:payment_type].to_s == 'online'#线上收费
							sch = ::Scheduler.new()
							sch.timer_at((order.created_at + 30.minutes),"::Orders::Order.find(#{order.id.to_s}).cancel_order({},'超时关闭')")
							result[:info].concat("请在#{(order.created_at + 30.minutes).to_s(:db)}之前完成订单支付")
						else
							# if attrs[:invoice_id].blank?
								# ::NoticeBroadcastJob.perform_later(data:data)
							# end
						end
						data = {
							ch:order.target_org_id,#药房id
							org_id:order.target_org_id,#药房id
							status:order.status, #订单状态
							order_id:order.id, #订单id
							created_at:order.created_at.strftime("%Y-%m-%d %H:%M"), #订单创建时间
							order_code:order.order_code, #订单号
							patient_name:order.patient_name, #患者名字
							amt:order.net_amt, #订单金额
							flag:true, #true已收费  false 退费
							info:'您有新的订单！', #订单金额
						}
						p "++++++++++++++++++++::NoticeChannel.publish(data)++++++++"
						::NoticeChannel.publish(data) rescue nil
						p data
						p "++++++++++++++++++++++++++++++"
					end
				rescue Exception => e
					p e.backtrace
					result = {ret_code:'-1',info:'当前处方订单生成失败。请提交反馈！'}
				ensure

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
		# def cancel_order(attrs = {})
		# 	attrs = attrs.deep_symbolize_keys
		# 	order = self.where(:id=>attrs[:id]).last
		# 	if order.status.to_s == '1'
		# 		order.update_attributes(status:'6',close_time:Time.now.to_s(:db))
		# 		args = {
		# 			# 创建订单人
		# 			create_bill_opt: {
		# 				id: attrs[:current_user].id,
		# 				display: attrs[:current_user].name,
		# 			},
		# 			# 订单创建时间
		# 			bill_at: order.created_at.to_s(:db),
		# 		  	bill_id: order.id,
		# 		}
		# 		order.prescriptions.each{|pre| pre.back_wait_charge(args, attrs[:current_user])}
		# 	end
		# end

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
			order = nil
			begin
				unless order = Orders::Order.where("id = ? and _locked = 0 and status in (1,2)",attrs[:id]).last
					result[:ret_code] = '-1'
					result[:info].concat("当前订单状态异常!,请稍后再试。")	
					return result
				end
				p "order_completion来更新订单了:#{attrs[:status]},#{order.id.to_s}"

				order.update_attributes(_locked:1)
				::Orders::Order.transaction do
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
					if result[:ret_code].to_s == '0'
						#订单结算
						if ["2","5"].include?attrs[:status].to_s
							# args = {
							# 	# 创建订单人
							# 	charger: {
							# 		id: attrs[:current_user].id,
							# 		display: attrs[:current_user].name
							# 		},
							# 	# 订单创建时间
							# 	charge_at: order.created_at.to_s(:db)
							# }
							# ##通知处方订单已结算
						 # 	order.prescriptions{|x|x.charged(args, attrs[:current_user])}
						 	#订单发药
							if ["5"].include?attrs[:status].to_s
								#发药标志改为1（已发药）
								order.update_attributes(:is_send_medical=>1)
							 # 	args2 = {
								# 	# 发药人
								# 	delivery: {
								# 		id: attrs[:current_user].id,
								# 		display: attrs[:current_user].name
								# 	},
								# 	# 发药时间
								# 	delivery_at: order.created_at.to_s(:db)
								# }
								# order.prescriptions{|x|x.send_drug(args2, attrs[:current_user])}
							end
							p "order_completion订单更新状态拉:#{attrs[:status]},#{order.id.to_s}"
							order.update_attributes(drug_user:attrs[:drug_user],
												drug_user_id:attrs[:drug_user_id],
												end_time:Time.now.to_s(:db),
												status:attrs[:status],
												)
							result[:info] = "订单已完成。" 
						end
						##更新处方状态。。。。。。
					end
				end
			rescue Exception => e
				p e.backtrace
				p '我的，都是我的！'
				result = {ret_code:'-1',info:'订单完成异常！'}
			ensure
				order.update_attributes(_locked:0)
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
			condtion = "(payment_type = 1 and status = 2 ) or (payment_type = 2)"
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
		def get_order_code target_org_id
			t = Time.now.beginning_of_day
			y = t.year.to_s[2,2]
			d = ("00" + t.yday.to_s)[-3,3]
			# target_org_id = ? AND   target_org_id,
			ser = ("0000" + (Orders::Order.where("created_at > ?",t).count+1).to_s)[-5,5]
			"#{y}#{d}#{ser}"
			# while Orders::Order.where("order_code = ? AND created_at < ?",code,t.beginning_of_day).last
			# 	code = get_order_code
			# end
			# {extension:'',code:''}
			# code
		end
	end #内方法
end



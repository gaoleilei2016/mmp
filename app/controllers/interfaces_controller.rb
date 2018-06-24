class InterfacesController < ApplicationController
	skip_before_action :verify_authenticity_token
	#############################
	############ zyz ############
	def get_orders
		if params[:id]
			o = ::Orders::Order.find(params[:id])
			raise "非法的账单查询，不是你的账单" if o.user_id.to_s != current_user.id.to_s
			base64_img = Set::QrCode.base64_data(o.order_code)
			re = JSON.parse(o.to_json)
			re["base64_img"] = base64_img
			re["drugs"] = o.details
			re["organ"] = ::Admin::Organization.find(o.target_org_id)
			re["total_price"] = o.net_amt
			# p '~~~~~~~~~~',::Customer::InvoiceHeader.find(o.invoice_id)
			re["invoice"] = ::Customer::InvoiceHeader.find(o.invoice_id) rescue nil
			return render json:{flag:true,order:re}
		end
		orders = ::Orders::Order.where(user_id:current_user.id).order("created_at desc").page(params[:page]).per(params[:per])
		ret = []
		orders.each{|o|
			re = JSON.parse(o.to_json)
			re["drugs"] = o.details
			re["organ"] = ::Admin::Organization.find(o.target_org_id)
			re["total_price"] = o.net_amt
			ret<<re
		}
		render json:{flag:true,rows:ret,total:orders.total_count}
		# render json:{flag:true,rows:[{},{},{}],total:4}
		# render json:{flag:true,rows:[],total:0}
	end
	#支付
	def pay_order
		order = ::Orders::Order.where("id=? and status = 1 ",params[:order_id]).last
		unless order
			flash[:notice] = "订单状态不允许支付。"
			redirect_to "/customer/portal/pay?id="+ params[:order_id].to_s
		end
		# order.net_amt ##订单号用机构id+订单号
		order.increment(:settle_times,1)
		order.save
		args = {out_trade_no: "#{order.id}_#{order.settle_times}", total_fee: order.net_amt.to_f.round(2), title: "华希订单-#{order.order_code}", cost_name: '药品', return_url: "#{Set::Alibaba.domain_name}/customer/home/confirm_order?id=#{order.id}&pay_type=#{params[:pay_type]}"}#/customer/portal/pay?id=#{order.id}
		# p '~~~~~~~~~',args
		case params[:pay_type]
		when "Alipay"
			res = Pay::Alipay.payment(args)
		when "Wechat"
			res = Pay::Wechat.payment(args)
		end
		# p '~~~~~~~ 2',res
		if res[:state].to_sym==:succ
			redirect_to res[:pay_url]
		else
			flash[:notice] = res[:desc]
			redirect_to "/customer/portal/pay?id="+ params[:order_id].to_s
		end
	end

	def show_order
		order = ::Orders::Order.find(params[:id])
		qr_code_img = Set::QrCode.base64_data(order.order_code)
		render json:{flag:true,order:order,qr_code_img:qr_code_img}
	end
	#微信，支付宝退款
	def refund_order
		order = ::Orders::Order.where("id=? AND status in (2,6) and _locked = 0",params[:id]).last
		return (render json:{flag:false,info:"当前订单状态不允许退费。"})unless order
		order.update_attributes(_locked:1)
		# order.net_amt ##订单号用机构id+订单号
		args = {out_trade_no: "#{order.id}_#{order.settle_times}", refund_fee: order.net_amt.to_f.round(2), reason:params[:reason],out_refund_no:Time.now.to_i}#/customer/portal/pay?id=#{order.id}
		res = Pay::Refund.carry_out(args)
		order.update_attributes(_locked:0)
		# p '~~~~~~~',res
		if [:succ,:success].include?res[:state].to_sym
			###退款成功
			order.cancel_order(current_user,'退款成功')
			# redirect_to res[:pay_url]
			flash[:notice] = "退款成功"
			render json:{flag:true,info:"操作成功"}
		else
			##退款失败
			# flash[:notice] = res[:desc]
			# redirect_to "/customer/portal/pay"
			render json:{flag:false,info:res[:desc]}
		end
	end

	# {"order"=>{"payment_type"=>"offline", "hospital_id"=>"33", "hospital_name"=>"第一个医院", "pharmacy_id"=>"37", "pharmacy_name"=>"摇啊摇", "prescription_ids"=>["63"]}}



	def save_order
		# params[:order][:user_id] = current_user.id
		# p '~~~~~~~~~~~~',params
		order = JSON.parse(params[:order].to_json)
		order[:current_user] = current_user
		if params[:use_invoice_header].to_s=="true"
			invoice_header = ::Customer::InvoiceHeader.find(params[:invoice_header_id]).dup
			invoice_header.user_id = nil
			invoice_header.type_class = params[:invoice_type_class]
			invoice_header.content = params[:invoice_content]
			invoice_header.save
			order[:invoice_id] = invoice_header.id
		end
		re = Orders::Order.create_order_by_presc_ids(order)
		flash[:notice] = re[:info]
		session[:cart_prescription_ids] = nil
		if re[:ret_code]!='0'
			return redirect_to "/customer/portal/settlement"
		end
		# p re
		# flash[:notice] = re[:info]
		if re[:order].payment_type.to_s == '2'
			redirect_to "/customer/home/order?id=#{re[:order].id}"
		else re[:order].payment_type.to_s == '1'
			redirect_to "/customer/portal/pay?id=#{re[:order].id}"
		end
	end
	def cancel_order
		ret = ::Orders::Order.find(params[:id]).cancel_order(current_user,'用户取消')
		flash[:notice] = ret[:info] if ret[:ret_code]=='0'
		render json: ret
	end
	# 获取用户购物车
	def get_prescriptions_cart
		raise "未选择药房" unless session[:cart_pharmacy_id].present?
		raise "未选择处方单" unless session[:cart_prescription_ids]&&session[:cart_prescription_ids].length>0
		ret = nil
		re = ::Hospital::Prescription.where(:id=>session[:cart_prescription_ids]).group_by {|_prescription| {org_id: _prescription.organization.id, org_name: _prescription.organization.name}}
		raise "药单出错，一次只能结算一个医院的药单" if re.keys.length != 1
		re.each do |cur_org, _prescriptions|
			prescription_ids = []
			total_price = 0.0
			orders = _prescriptions.map { |e| prescription_ids<<e.id;e.orders}.flatten.map { |k| total_price+=k.price*k.total_quantity;k.to_web_front;  }
			cur_org[:prescription_ids] = prescription_ids
			cur_org[:total_price] = total_price
			cur_org[:orders] = orders
			ret = cur_org
		end
		render json: {flag: true, info: "success", prescription: ret,pharmacy: ::Admin::Organization.find(session[:cart_pharmacy_id])}
	end
	# 设置用户购物车
	def set_prescriptions_cart
		# p '~~~~~~~~~',params
		session[:cart_pharmacy_id] = params[:pharmacy_id]
		session[:cart_prescription_ids] = params[:ids]
		render json:{flag:true,info:"操作成功"}
	end
	# 用户选择药房
	def set_current_pharmacy
		session[:current_pharmacy_id] = params[:id]
		org = ::Admin::Organization.find(params[:id])
		org.search_count ||= 0
		org.search_count = org.search_count.to_i + 1
		org.save
		his = ::Customer::PharmacyHistory.where(user_id:current_user.id,pharmacy_id:org.id).first
		max_count_add_1 = ::Customer::PharmacyHistory.where(user_id:current_user.id).order('use_count desc').first.try(:use_count).to_i+1
		if his
			his.use_count = max_count_add_1
			his.save
		else
			::Customer::PharmacyHistory.create(user_id:current_user.id,pharmacy_id:org.id,use_count:max_count_add_1)
		end
		render json:{flag:true,info:"操作成功"}
	end
	# 获取用户选择的药房，默认最近的药房（用户传参：当前位置）
	def get_current_pharmacy
		# p '~~~~~~~',params, session[:current_pharmacy_id]
		if session[:current_pharmacy_id]
			# 自选
			o = ::Admin::Organization.where(:type_code=>'2',id:session[:current_pharmacy_id]).first
			raise "查无此药房 id:#{session[:current_pharmacy_id]}" unless o

			re = JSON.parse(o.to_json)
			if o.lat.present? && o.lng.present? && params[:lat].present? && params[:lng].present?
				args = {lat: params[:lat].to_f, lng:  params[:lng].to_f}
				tar = {lat: o.lat.to_f, lng:  o.lng.to_f}
				dis = Admin::Organization.distance_list(args,tar)
				re['distance'] = dis[:res]
			end

			render json:{flag:true,pharmacy:re,type:"self"}
		else
			# 最近
			# p '~~~~~~~~~~~',params
			raise "定位错误，请自选药房" unless params[:lat].present?&&params[:lng].present?
			args = {lat: params[:lat].to_f, lng:  params[:lng].to_f, num: 1}
			recents = ::Admin::Organization.recent_lists(args)
			# p '~~~~~~~~~~',recents
			if recents[:state] == :succ
				re = JSON.parse(recents[:res][0][:org].to_json)
				re['distance'] = recents[:res][0][:distance]
				# p '~~~~~~~~~~~',re
				render json:{flag:true,pharmacy:re,type:"near"}
			else
				render json:{flag:false,info:recents[:desc],type:"near"}
			end
		end
	end
	def get_pharmacy
		org = current_user.organization
		if org
			raise "非医院的用户" unless org.type_code=='1'
			# 医院用户选择合作药房
			if org.yaofang_type
				orgs = org.pharmacy_link.map{|x| x.pharmacy}.compact
			else
				orgs = ::Admin::Organization.where(:type_code=>'2')
			end
			render json:{rows:orgs,total:orgs.count,flag:true}
		else
			args = {lat: params[:lat].to_f, lng: params[:lng].to_f}
			if params[:near].present?
				args[:num] = 3
				# 客户获取最近的药房
				recents = ::Admin::Organization.recent_lists(args)
				# p '~~~~~~~~~~ near',recents
				if recents[:state] == :succ
					orgs = recents[:res].map{|x| x[:org]}
				else
					orgs = []
				end
			elsif params[:hot].present?
				# 客户获取大家热点药房
				orgs = ::Admin::Organization.where(:type_code=>'2').order("search_count desc").page(1).per(5)
			elsif params[:history].present?
				# 客户获取历史记录药房
				his = ::Customer::PharmacyHistory.where(user_id:current_user.id).order("use_count desc").page(1).per(5)
				orgs = his.map{|x| o = ::Admin::Organization.find(x.pharmacy_id); o.type_code=='2' ? o : nil }.compact
			else
				# 客户搜索药房
				orgs = ::Admin::Organization.where(:type_code=>'2').where("id like '%#{params[:search]}%' OR name like '%#{params[:search]}%' OR jianpin like '%#{params[:search]}%' OR addr like '%#{params[:search]}%'").order("created_at desc").page(params[:page]).per(params[:per])
			end
			res = []
			orgs.each{|o|
				re = JSON.parse(o.to_json)
				if o.lat.present? && o.lng.present? && params[:lat].present? && params[:lng].present?
					tar = {lat: o.lat.to_f, lng:  o.lng.to_f}
					dis = Admin::Organization.distance_list(args,tar)
					re['distance'] = dis[:res]
					re['num'] = dis[:num]
				end
				res<<re
			}
			if params[:hot].present?||params[:history].present?||params[:near].present?
				# 历史记录 / 大家常用
			else
				# 药房搜索按距离排序
				res.sort_by!{|x| x["num"]}
			end
			if params[:history].present?||params[:near].present?
				render json:{rows:res,total:orgs.count,flag:true}
			else
				render json:{rows:res,total:orgs.total_count,flag:true}
			end
		end
	end
	def get_yanzhengma
		render "/layouts/yanzhengma.html.erb",layout:false
	end
	def get_duanxinma
		# p '~~~~~~~~~~',params[:login]
		# 图片验证码
		# raise "图片验证码错误" unless verify_rucaptcha?
		raise "手机号错误" unless params[:login].present?
		args = {:phone=>params[:login], :data_type=>"verify_code", :name=>""}
		res = Sms::Message.set_up(args)
		# 成功：{:state=>:succ, :msg=>"短信发送成功", :verify_code=>code}
		# 失败：{state: :fail, msg: '失败', desc: '描述'}
		raise res[:desc] if res[:state]!=:succ
		render json:{flag:true,info:"发送成功"}
	end
	############ zyz ############
	#############################

	#############################
	############ xixu ############
	def get_dicts    #根据字典编号获取字典数据
		params[:oid]
		ret = ::User.find_by_sql("select  dictdata.code ,dictdata.name  from dictdata where dictdata .oid='#{params[:oid]}'")
		render json:{rows:ret,total:ret.count}
	end
	



	def get_addrs   ##根据编码获取行政区划地址
		params[:code]
		ret = ::User.find_by_sql("select  a.*  from dictarea a  where  ('#{params[:code]}'='' and a.supcode is null) or ('#{params[:code]}'<>'' and a.supcode='#{params[:code]}')  and a.status<>'T'")
		render json:{rows:ret,total:ret.count}
	end

  

def get_medicine_by_name
		params[:name]
		ret = ::User.find_by_sql("select *  from dictmedicine where dictmedicine.name  like '%#{params[:name]}%'")
		render json:{rows:ret,total:ret.count}
	end

    ############ xixu ############
	#############################

end

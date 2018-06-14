class InterfacesController < ApplicationController
	skip_before_action :verify_authenticity_token
	#############################
	############ zyz ############
	def pay_order
		# p '~~~~~~~~~',params
		order = params[:pay_order]
		args = {out_trade_no: order, total_fee: 0.01, title: '支付后会通知药房备药', cost_name: '', return_url: '/customer/home'}
		case params[:pay_type]
		when "Alipay"
			res = Pay::Alipay.payment(args)
		when "Wechat"
			res = Pay::Wechat.payment(args)
		end
		# p '~~~~~~~',res
		if res[:state]==:succ
			redirect_to res[:pay_url]
		else
			flash[:notice] = res[:desc]
			redirect_to "/customer/portal/pay"
		end
	end
	def save_order
		# p '~~~~~~~~~',params
		redirect_to '/customer/portal/pay'
	end
	# 获取用户购物车
	def get_prescriptions_cart
		raise "未选择药单" unless session[:cart_pharmacy_ids]&&session[:cart_pharmacy_ids].length>0
		ret = nil
		re = ::Hospital::Prescription.where(:id=>session[:cart_pharmacy_ids]).group_by {|_prescription| {org_id: _prescription.organization.id, org_name: _prescription.organization.name}}
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
		render json: {flag: true, info: "success", data: ret}
	end
	# 设置用户购物车
	def set_prescriptions_cart
		session[:cart_pharmacy_ids] = params[:ids]
		render json:{flag:true,info:"操作成功"}
	end
	# 用户选择药房
	def set_current_pharmacy
		session[:current_pharmacy_id] = params[:id]
		render json:{flag:true,info:"操作成功"}
	end
	# 获取用户选择的药房，默认最近的药房（用户传参：当前位置）
	def get_current_pharmacy
		if session[:current_pharmacy_id]
			# 自选
			ph = ::Admin::Organization.where(:type_code=>'2').find(session[:current_pharmacy_id])
			render json:{flag:true,pharmacy:ph,type:"self"}
		else
			# 最近
			ph = ::Admin::Organization.where(:type_code=>'2').first
			render json:{flag:true,pharmacy:ph,type:"near"}
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
			render json:{rows:orgs,total:orgs.count}
		else
			# 客户选择常用药房
			orgs = ::Admin::Organization.where(:type_code=>'2').where("id like '%#{params[:search]}%' OR name like '%#{params[:search]}%' OR jianpin like '%#{params[:search]}%'").order("created_at desc").page(params[:page]).per(params[:per])
			render json:{rows:orgs,total:orgs.total_count}
		end
	end
	def get_yanzhengma
		render "/layouts/yanzhengma.html.erb",layout:false
	end
	def get_duanxinma
		# p '~~~~~~~~~~',params[:login]
		# 图片验证码
		raise "图片验证码错误" unless verify_rucaptcha?
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

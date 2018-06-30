class User < ApplicationRecord
	belongs_to :organization, class_name:"Admin::Organization", optional: true
	# has_many :search_histories, class_name:"SearchHistories"
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	validates_presence_of :login
	validates_uniqueness_of :login
	devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable
	# :pharmacy_id 客户的常用药房id
	# :admin_level 管理级别  1-管理员
	# def initialize opt=nil
	# 	super opt
	# end
	# def save attrs={}
	# 	# p '~~~~~~~~ user save',attrs
	# 	if self.organization
	# 		self.type_code = self.organization.type_code
	# 	end
	# 	super attrs
	# end
	has_one :weight_bmi,     class_name: 'Health::Weight'        #体重分析
  has_one :blood_pressure, class_name: 'Health::BloodPressure' #血压分析

	def is_admin?
		admin_level=='1'
	end
	def get_config ii
		con = ::Customer::Config.where(user_id:self.id,ii:ii.to_s).first
		if con
			con
		else
			con = ::Customer::Config.create(user_id:self.id,ii:ii.to_s)
		end
	end
	def set_config ii,flag
		con = get_config ii
		con.update_attributes(flag:flag)
	end

	#健康小站=========================
	def health_paid?
		ex = Time.parse(expired_in) rescue nil
		return false unless ex
		ex > Time.now
	end

	def age
    t1 = Time.parse(birth)
    t2 = Time.now
    (t2-t1).to_i/(60*60*24*30*12)-1
  end

	# 获取体重数据分析
  def get_weight_bmi
    ws_weight = HealthCloud::WsWeight.where(userid: self.id.to_s).last rescue nil
    return { error: true, msg: '没有体重测量数据' } unless ws_weight
    res = {sex: self.sex, age: age, height: handle_height, data: ws_weight.floWeight, user: self}
    return update_weight_bmi(res) if self.weight_bmi.present?
    create_weight_bmi(res)
  end

  # 获取血压数据分析
  def get_blood_data
    begin
      ws_blood = HealthCloud::WsBlood.where(userid: self.id.to_s).last rescue nil
      return { error: true, msg: '没有血压测量数据' } unless ws_blood
      res = { systolic_value: ws_blood.intSystolic, diastolic_value: ws_blood.intDiastolic }
      return update_blood_data(res) if self.blood_pressure.present?
      bp = Health::BloodPressure.create_record(res.merge({user: self}))
      return { error: false, msg: '成功获得数据', result: bp[:rec].result, user: self } unless bp[:error]
      bp      
    rescue Exception => e
      { error: true, msg: e.message }
    end
  end

  def update_blood_data(res)
    return { error: false, msg: '成功获得数据', result: self.blood_pressure.result} if res[:diastolic_value].eql?(self.blood_pressure.diastolic_value)
    return { error: false, msg: '成功获得数据', result: self.blood_pressure.result} if self.blood_pressure.update_attributes(Health::BloodPressure.handle_data(res))
    { error: true, msg: "获取数据失败: #{self.blood_pressure.errors.full_messages.join(',')}" }
  end

  def update_weight_bmi(res)
    return { error: false, msg: '成功获得数据', result: self.weight_bmi.result} if res[:sex].eql?(self.weight_bmi.sex) && res[:age].eql?(self.weight_bmi.age) && res[:height].eql?(self.weight_bmi.height) && res[:data].eql?(self.weight_bmi.data)
    return { error: false, msg: '成功获得数据', result: self.weight_bmi.result} if self.weight_bmi.update_attributes(Health::Weight.handle_data(res))
    { error: true, msg: "获取数据失败: #{self.weight_bmi.errors.full_messages.join(',')}" }
  end

  def create_weight_bmi(res)
    w = Health::Weight.create_record(res)
    return w if w[:error]
    return { error: false, msg: '成功获得数据', result: w[:rec].result, user: self } if self.update_attributes({weight_bmi: w[:rec]})
    { error: true, msg: "获取数据失败：#{w.errors.full_messages.join(',')}" }
  end

  def handle_height
    self.height.to_i/100.0
  end
	#================================= 

	# 调用： user.push_wowgo
	# 返回结果：
	#   错误：{state: :error, msg: '推送错误', desc: '错误描述'}
	#   失败：{state: :fail, msg: '请求成功/失败', desc: '失败描述'}
	#   成功：{state: :succ, msg: '成功', desc: '推送伺服器成功'}
	#   推送高登成功但更新user错误：
	#   {state: :error, msg: '推送伺服器成功但更新失败', desc: '更新失败描述'}
	def push_wowgo
		datas = {user_name: login, height: height, birth: birth, 
			headimgurl: headimgurl, gender: handle_gender}
		datas.merge!({api_code: 'update_user'}) if wowgo
		datas.merge!({api_code: 'new_user'}) unless wowgo
		res = Health::Wowgo.new(datas)
		return {state: :error, msg: '推送错误', desc: res.errors.full_messages.join(',')} unless res.save
		ret = res.push_info
		if ret[:desc] == "帳號重複"
			self.update_attributes({wowgo: true})
			return {state: :fail, msg: ret[:msg], desc: "#{ret[:desc]}（已修复，请尝试重新保存）"}
		end
  	return {state: :fail, msg: ret[:msg], desc: ret[:desc]} unless ret[:state].eql?('succ')
	  return {state: :succ, msg: '成功', desc: '推送伺服器成功'} if self.update_attributes({wowgo: true})
		{state: :error, msg: '推送伺服器成功但更新失败', desc: self.errors.full_messages.join(',')}
	end

	def get_qr_code
		return {state: :error, msg: '错误', desc: '请先把数据推送到高登'} unless wowgo
		qrcode = Health::QrCode.find_by(code: login)
		return {state: :error, msg: '未找到', desc: '相应的二维码未找到'} unless qrcode
		{state: :succ, msg: '成功', base64: "data:image/png;base64,#{Base64.encode64(qrcode.img_data)}"}
	end

	def handle_gender
		case sex
		when '女' then 'F'
		when '男' then 'M'
		else
			'U'	
		end
	end
end

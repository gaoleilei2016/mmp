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
	def is_admin?
		admin_level=='1'
	end

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
  	return {state: :fail, msg: ret[:msg], desc: ret[:desc]} unless ret[:state].eql?('succ')
	  return {state: :succ, msg: '成功', desc: '推送伺服器成功'} if self.update_attributes({wowgo: true})
		{state: :error, msg: '推送伺服器成功但更新失败', desc: self.errors.full_messages.join(',')}
	end

	def get_qr_code
		return {state: :error, msg: '错误', desc: '请先把数据推送到高登'} unless wowgo
		qrcode = Health::QrCode.find_by(code: login)
		return {state: :error, msg: '未找到', desc: '相应的二维码未找到'} unless qrcode
		{state: :succ, msg: '成功', base64: "data:image/png;base64,#{qrcode.img_data}"}
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

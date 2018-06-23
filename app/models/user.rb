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
end

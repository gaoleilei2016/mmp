class User < ApplicationRecord
	belongs_to :organization, class_name:"Admin::Organization", optional: true
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	validates_presence_of :login
	validates_uniqueness_of :login
	devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable
	# def initialize opt=nil
	# 	super opt
	# end
	def save attrs={}
		# p '~~~~~~~~ user save',attrs
		if self.organization
			self.type_code = self.organization.type_code
		end
		super attrs
	end
end

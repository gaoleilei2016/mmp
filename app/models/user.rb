class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	validates_presence_of :login
	devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable
	def initialize opt=nil
		# p opt
		super opt
	end
end

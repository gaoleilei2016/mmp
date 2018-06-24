class Hospital::DictCoding < ApplicationRecord

	validates :code, :display, :system, presence: {message: "不能为空"}

	def initialize
		self.status ||= "A"
	end
end

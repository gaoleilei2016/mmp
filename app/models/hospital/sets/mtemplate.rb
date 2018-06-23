class ::Hospital::Sets::Mtemplate < ApplicationRecord

	validates :org_id, :status, :title, :sharing_scope_code, :sharing_scope_display, :disease_code, :disease_display, :author_id, :author_display, :location_id, :location_display, presence: {message: "不能为空"}

	belongs_to :organization,  class_name: "::Admin::Organization",       foreign_key: 'org_id'
	belongs_to :author,  class_name: "::User",       foreign_key: 'author_id'
	belongs_to :location,  class_name: "::Hospital::Sets::Department",       foreign_key: 'location_id'
	has_many :orders, class_name: "Hospital::Order", foreign_key: 'mtemplate_id'

	def initialize args = {}
		super args
		# 默认状态是已激活
		self.status ||= "A"
		# 默认权限是自己
		self.sharing_scope_code ||= "0"
		self.sharing_scope_display ||= "自己"
	end

	def to_web_front
		ret = {
			id: self.id,
			status: self.status,
			title: self.title,
			note: self.note,
			sharing_scope: {
				code: self.sharing_scope_code,
				display: self.sharing_scope_display
			},
			disease:{
				code: self.disease_code,
				display: self.disease_display
			},
			author:{
				id: self.author_id,
				display: self.author_display
			},
			location:{
				id: self.location_id,
			    display: self.location_display
			},
			organization: {
				id: self.org_id
			},
			created_at: self.created_at,
			updated_at: self.updated_at,
			orders: self.orders.map { |e| e.to_web_front  }
		}
	end

	class<<self
	end
end

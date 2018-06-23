class ::Hospital::Sets::Department < ApplicationRecord

	# 验证数据存在性
	validates :org_id, :name, :status, presence: {message: "不能为空"}

	# 数据的长度控制后面再加 (未完成)

	# 应用层根据机构id做一个名称的唯一性效验
	validates :name, uniqueness: {scope: :org_id, message: "不能重复"}

	# 每一个设置的科室必须存在机构
	belongs_to :organization,  class_name: "::Admin::Organization",       foreign_key: 'org_id', optional: true

	def initialize args = {}
		super args
		self.status ||= "A"
	end

# 待加控制 
# 已经分配了的科室  还能不能作废问题  需要控制
end
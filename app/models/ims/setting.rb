#encoding:utf-8
# => 药店-设置(根据自己机构设置)
class Ims::Setting < ApplicationRecord
	# 字段
	# {
	# 	id: integer,     # id
	# 	org_ii: string,     # 组织机构id
	# 	org_name: string,     # 组织机构名称
	# 	returned_at: integer,     # 退药时间天数
	# 	payment_expired: integer,     # 付费未取药过期天数
	# 	unpaid_expired: integer,     # 未支付订单过期天数
	# 	created_at: datetime,     # 
	# 	updated_at: datetime    # 
	# }
end

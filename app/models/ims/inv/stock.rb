#encoding:utf-8
# => 药店-库存表
class Ims::Inv::Stock < ApplicationRecord

	def update_or_create_stock update_data={}
		
	end
	# rails generate scaffold Ims::Inv::Stock org_id:integer medicine_id:integer pt_code:string code:string unit:string price:string mul:string batch:string location_id:string location_name:string quantity:float freeze_qty:float amount:float created_at:datetime updated_at:datetime
	# bundle exec rake db:migrate
	# id             # 库存表ID
	# org_id         # 组织机构id
	# medicine_id    # 药品ID
	# pt_code        # 平台药品code
	# code           # 药品code
	# unit           # 单位
	# price          # 价格
	# mul            # 销售/基本单位的倍率
	# batch          # 批号
	# location_id    # 批号
	# location_name  # 药库名称
	# quantity       # 库存数量
	# freeze_qty     # 冻结数量
	# amount         # 金额
	# created_at     # 建立时间
	# updated_at     # 更新时间

end

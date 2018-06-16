class ::Dict::Medication < ApplicationRecord
	# belongs_to :order, class_name: '::Orders::Order', foreign_key: 'encounter_id'
	

	# 设置查询表
	 def self.table_name
    	'dictmedicine'
  	end

  	def to_hash
  		self.attributes
  	end

  	# 能否开此药品
  	def can_create?
  		self.status == "A" ? true : false
  	end

  	def to_order_info
  		{
  			serialno: self.serialno,
  			title: self.name,
  			specification: self.spec,
  			unit: self.unit,
			price: self.price,
			formul_code: self.formul_code,
			formul_display: self.formul_name
  		}
  	end
end
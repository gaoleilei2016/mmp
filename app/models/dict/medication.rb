class ::Dict::Medication < ApplicationRecord
	# belongs_to :order, class_name: '::Orders::Order', foreign_key: 'encounter_id'
	

	# 设置查询表
	 def self.table_name
    	'dictmedicine'
  	end

  	def to_hash
  		self.attributes
  	end
    
end
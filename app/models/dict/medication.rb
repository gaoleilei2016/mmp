class ::Dict::Medication < ApplicationRecord
	

	# 设置查询表
	 def self.table_name
    	'dictmedicine'
  	end

  	def to_hash
  		self.attributes
  	end
    
end
class ::Dict::Disease < ApplicationRecord
	

	# 设置查询表
	 def self.table_name
    	'dictdisease'
  	end

  	def to_hash
  		self.attributes
  	end

  	def to_ICD10_fhir_type
  		{
  			code: self.ICD10,
  			display: self.name,
  			system: 'ICD10'
  		}
  	end
end
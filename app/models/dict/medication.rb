class ::Dict::Medication < ApplicationRecord
	# belongs_to :order, class_name: '::Orders::Order', foreign_key: 'encounter_id'
	

	# 设置查询表
	 def self.table_name
    	'dictmedicine'
  	end

  	def to_hash
  		ret = self.attributes
      # 临时测试代码  随机库存
      ret.merge!(storage: 5.times.map { |e| rand(10)  }.sort {|x,y| y <=> x})
  	end

  	# 能否开此药品
  	def can_create?
  		self.status == "A" ? true : false
  	end

    # 对应的字段都是医嘱的字段
  	def to_order_info
  		{
  			serialno: self.serialno,
  			title: self.name,
  			specification: self.spec,
  			unit: self.unit,
  			price: self.price,
  			formul_code: self.formul_code,
  			formul_display: self.formul_name,
        factory_name: self.produce_name,
        base_unit: self.base_unit,
        mul: self.mul,
        measure_val: self.measure_val,
        measure_unit: self.measure_unit
    	}
  	end
end
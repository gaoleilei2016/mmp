class ::Hospital::Dict::NewMedication < ApplicationRecord
	
  # 注意  直接从表里面取出来的字段类型 有些需要转换   转换Time String  Fixnum
	# 设置查询表
	  def self.table_name
    	'new_dictmedicine'
  	end

  	def to_hash
  		ret = self.attributes.deep_symbolize_keys
      ret[:measure_val] = self.measure_val.to_f
      ret[:mul] = self.mul.to_f
      ret[:purch_mul] = self.purch_mul.to_f
      ret[:purch_price] = self.purch_price.to_f
      ret[:price] = self.price.to_f
      ret[:storage] = [self.quantity]
      ret[:return_price_flag]  =  (rand(0..1) == 0 ? false : true) #返款标记
      ret[:pharmacology_code]  =  0 #药理学分类编码 编码系统
      ret[:indications]  =  "感冒|发烧|头疼" #适应症
      # 临时测试代码  随机库存
      # ret.merge!(storage: 5.times.map { |e| rand(10)  }.sort {|x,y| y <=> x})
      ret
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
  			price: self.price.to_f,
  			formul_code: self.formul_code,
  			formul_display: self.formul_name,
        factory_name: self.produce_name,
        base_unit: self.base_unit,
        mul: self.mul.to_f,
        measure_val: self.measure_val.to_f,
        measure_unit: self.measure_unit
    	}
  	end

    class<<self
      #  只接收药品id
      def find(medicine_id)
        ::Hospital::Dict::NewMedication.where("medicine_id" => medicine_id).first
      end
    end
end
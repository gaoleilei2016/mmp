class ::Dict::Coding < ApplicationRecord

  SYSTEM = {
    "gender" => "2.16.156.1.19449.1.2261.1", # 性别编码表
    "country" => "2.16.156.1.19449.1.2659", # 国家编码表
    "nation" => "2.16.156.1.19449.1.3304"
  }
	

	# 设置查询表
	 def self.table_name
    	'dictdata'
  	end

  	def to_hash
  		self.attributes
  	end

    def to_web_front
      {
        id: self.serialno,
        org_id: self.ii_root,
        system: self.oid,
        code: self.code,
        display: self.name,
        ordid: self.ordid,
        jianpin: self.py,
        wubi: self.wb,
        version: "",
        status: self.status,
        created_at: nil,
        updated_at: nil
      }
    end

    def self.get_code_by_system(system)
      ret = ::Dict::Coding.where(oid: system).map {|e| e.to_web_front}
      return  ret
    end

    def self.get_code_by_name(name)
      ret = ::Dict::Coding.get_code_by_system(::Dict::Coding::SYSTEM[name.to_s])
      return ret
    end
end
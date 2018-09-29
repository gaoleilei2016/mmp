#encoding:utf-8
# => 药店-库存表
class Ims::Inv::Stock < ApplicationRecord

	class << self

		# 创建
		def create_stock args = {}
		end

		# 库存查询
		def search_stocks args = {}
        	begin
				org_id = args[:org_id]
				location_id = args[:location_id]
				search = args[:search]
				sql = "SELECT * FROM dictmedicine d inner join ims_inv_stocks s on s.medicine_id=d.serialno where s.location_id=#{location_id}  and s.org_id=#{org_id} and (d.py like '%#{search}%' or d.wb like '%#{search}%' or d.name like '%#{search}%' or d.common_name like '%#{search}%' or d.common_py like '%#{search}%' or d.common_wb like '%#{search}%' or d.spec like '%#{search}%')"
				result = self.find_by_sql(sql)
	        	JSON.parse(result.to_json)
        	rescue Exception => e
        		print e.message rescue "  e.messag----"
		        print "laaaaaaaaaaaaaaaaaaaa 库存查询 出错: " + e.backtrace.join("\n")
		        result = {flag:false,:info=>"药店系统出错。"}
        	end
		end

		# 创建配置文件
  		#  库存导入接收文件
		def exports args={}
			begin
				file_name = args[:file_name]
				org_id = args[:org_id]
			    location_id = args[:location_id]
				location_name = args[:location_name]
			    path="up_xls/"+file_name.to_s
			    config_ta=["商品编码","商品编码","单位","售价","数量(A)","售价金额"]#1,3,8
			    config_my=["pt_code","code","unit","price","quantity","amount"]
			    # 获取excel
			    save_ar=save_ar_hash(path,config_ta,config_my)
				runsql=ActiveRecord::Base.connection()
			    save_ar.each{ |aa|
				    # ----------更新---------
				    select_pt={pt_code:aa["pt_code"],org_id:org_id}
				    selct_ims_sql = "select id from ims_inv_stocks where pt_code=#{aa["pt_code"]} and org_id=#{org_id}"
				    selct_ims=self.find_by_sql selct_ims_sql
				    puts "-查询#{selct_ims}-----"
				    if(selct_ims.count!=0)
				    	amount = (aa['quantity'].to_f*aa["price"].to_f).round(2)
				      	update_sql="update ims_inv_stocks set quantity=#{aa['quantity'].to_f},amount=#{amount} where id=#{selct_ims[0].id} and org_id=#{org_id}"
				      	puts "------#{update_sql}--------"
				      	runsql.update update_sql
				      	# return {flag:true,info:"更新成功。"} 
				    else
				    	sql = "select * from dictmedicine where effect_code=#{aa['pt_code']} "
				    	ret = self.find_by_sql sql
				    	drug = JSON.parse(ret[0].to_json) rescue nil
				    	return {flag:false,info:""} if drug.blank?
				    	amount = (aa['quantity'].to_f*aa["price"].to_f).round(2)
				    	create_data = {
				    		:org_id=> org_id,
							:medicine_id=> drug["serialno"],
							:pt_code=> drug["effect_code"],
							:code=> '',
							:unit=> aa["unit"],
							:price=> aa['price'].to_f.round(4),
							:mul=> drug["mul"],
							:batch=> "",
							:location_id=> location_id,
							:location_name=> location_name,
							:quantity=> aa["quantity"].to_f.round(2),
							:freeze_qty=>0 ,
							:amount=> amount,
				    	}
				    	self.create(create_data)
				    	# return {flag:true,info:""} if self.create(create_data)
				    end
				    # return {flag:false,info:""}
			    }
			    return {flag:true,info:"库存导入保存成功!"}
			rescue Exception => e
				print e.message rescue "  e.messag----"
		        print "laaaaaaaaaaaaaaaaaaaa 库存导入保存文件 出错: " + e.backtrace.join("\n")
		        result = {flag:false,:info=>"药店系统出错。"}
			end
		end


		
		# 获取标号
		def get_xls_column
			["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
		end
		# 
		def num_to_str column_num
			a=column_num/26
			b=column_num%26
			[a,b]
		end
		# 第几行-字母-0开始
		def get_column_str i
			ar=num_to_str i
			c=get_xls_column
			qian=c[ar[0]-1]
			# 一
			if(ar[0]<1)
				qian=""
			end
			# 二
    		qian+c[ar[1]]
    		# 三
		end
		# --获取文件第一行--
		def get_xls_row workSheet
            first_xls_ar=[]
            i=0
          	while true
                column_str=get_column_str i
                aa=readXls workSheet,column_str,1
                if (aa != "" && aa != nil )
                  first_xls_ar<<aa
                else
                  return first_xls_ar
                end
                i+=1
	         end
	    end
       	# 读取 列名为column，行数为num
	   	def readXls workSheet,column,num
	   		workSheet.cell(column,num)
	   	end
	   	# ---读取文件
	   	def getXls path
	   		begin
		        xlsx = Roo::Spreadsheet.open(path, extension: :xls)
		    rescue Exception => e
		        xlsx = Roo::Spreadsheet.open(path, extension: :xlsx)
		    end
	   		ods = xlsx.sheet(0)
	   		[ods,xlsx]
	   	end
	    def save_ar_hash path,config_ta,config_my
	        arr=getXls path#--返回一个数组，第一个用于取值，第二个用于关闭文件
	        first_value=get_xls_row(arr[0])#库存更新第一行
	        aa=file_touch(config_ta,first_value)#所需列
	        column_str_my=[]
	        for i in (0...aa.size)
	          column_str=get_column_str aa[i]
	          column_str_my<<column_str
	        end
	              # 取值
	        save_ar_hash=[]
	        i=2;
	          while true
	            use_ar=[]
	           for j in (0...column_str_my.size)
	              value_use=readXls arr[0],column_str_my[j],i
	              use_ar<<value_use
	           end
	           break if(use_ar[0]=="" ||  use_ar[0]==nil)
	            hhhhh =get_hash(config_my,use_ar)
	            save_ar_hash<<hhhhh
	            i+=1
	        end  
	        arr[1].close   
	        save_ar_hash   
	    end
        # --配置文件config_ar，-xls文件第一行xlsx_ar-
        def file_touch config_ar,xlsx_ar
		 	jilu=[]
		 	#--1.go
	 		for i in (0...config_ar.size)
	 			for j in (0...xlsx_ar.size)
	 				if(config_ar[i].to_s == xlsx_ar[j].to_s)
	 					jilu<<j
	 					break;
	 				end
	 			end
	 		end
	 		return jilu
		end
    	#---ar_key键数组，值数组----
 		def get_hash ar_key,ar_values
			hash={}
			for i in (0...ar_key.size)
				hash.store(ar_key[i].to_s,ar_values[i].to_s)
			end
			hash
		end

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

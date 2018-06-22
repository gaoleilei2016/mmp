#encoding:utf-8
# => 药店-报表
class Ims::Report
	class << self

		# => 药店药品销售情况
		# => [当前机构、来源机构、发药时间区间、发药人、]
    # args ={org_id:'34',start_time:'2018-06-20',end_time:'2018-06-21',status:5}
		def sale_report args = {}
      begin
  			org_id = args[:org_id]
        start_time = args[:start_time] || (Time.new - 1.day).to_s(:db)
        end_time = args[:end_time] || Time.new.to_s(:db)
        status = args[:status]
        sql = "SELECT  b.title,b.specification,b.factory_name,sum(b.qty) as 'total_qty',b.unit,b.price,round(sum(b.amount),2) as 'total_amount',GROUP_CONCAT(a.id) as 'ids' FROM pre_headers a INNER JOIN pre_details b on a.id= b.header_id where a.delivery_org_id='#{org_id}'" 
        status.blank? ? sql.concat(" and (a.status=4 or a.status=8 )") : sql.concat("and (a.status=#{status} )")
        sql.concat(" and a.created_at BETWEEN '#{start_time}' AND '#{end_time}' GROUP BY  b.title,b.specification,b.factory_name,b.unit,b.price;")
        result = Ims::PreHeader.find_by_sql(sql)
        JSON.parse(result.to_json)
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "laaaaaaaaaaaaaaaaaaaa 订单明细信息及处方信息查询 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
		end

		# 订单搜索
		def order_search args={}
			data = []
      return {flag:false,:info=>"药店机构为空。"} if args[:org_id].blank?
      # sql =" SELECT * FROM orders_orders where target_org_id = #{args[:org_id]}"
      query ="target_org_id = #{args[:org_id]}"
      query.concat(" and order_code=#{args[:order_code]}") unless args[:order_code].blank?
      case  args[:type].to_s
      when '1'#未付款
       query.concat(" and payment_type = 2 and status=1 ")
      when '2'#已付款
       query.concat(" and status=2 ")
      when '5'#已发药
       query.concat(" and status=5 ")
      when '7'#已退药
       query.concat(" and status=7 ")
      else
      end
      Orders::Order.where(query).map{|order| 
      preson = Person.find order.person_id rescue nil
      data <<{
	      order_id: order.id,
	      order_code: order.order_code,
	      amt: order.net_amt,
	      status: order.status,
	      payment_at: order.payment_at,     # 支付时间
	      end_time: order.end_time,     # 订单完成时间
	      close_time: order.close_time,
	      target_org_name: order.target_org_name,
	      source_org_name: order.source_org_name,
	      doctor: order.doctor,
	      prescriptions_id: order.prescription_ids,
	      prescriptions_count: order.try(:prescription_ids).count,
	      patient_name: order.patient_name,
	      patient_sex: order.patient_sex,
	      patient_age: order.patient_age,
	      patient_iden: order.patient_iden,
	      patient_phone: order.patient_phone,
	      payment_type: order.payment_type,
	      is_returned: order.is_returned,
	      details: order.details.map{|x| {
              name: x.name,
              quantity: x.quantity,
              unit: x.unit,
              specifications: x.specifications,
              dosage: x.dosage,
              price: x.price,
              net_amt: x.net_amt,
              firm: x.firm,
              img_path: x.img_path
            }
          }
	      }
	    }
    	return {flag:true,data:data}
		end

		# 待发药、未成交订单统计(变动的数据统计)
		# 条件(时间、患者、医院、医生)
		# SELECT  b.name,b.specifications,b.firm,sum(b.quantity) as 'total_qty',b.unit,b.price,round(sum(b.net_amt),2) as 'total_amount',GROUP_CONCAT(a.id) 
		# FROM orders_orders a INNER JOIN orders_order_details b on a.id= b.order_id 
		# where a.target_org_id=38 and a.created_at 
		# BETWEEN '2018-06-17' AND date_add('2018-06-19',interval 1 day) #GROUP BY b.name
		# GROUP BY  b.name,b.specifications,b.firm,b.unit,b.price;
    # args ={org_id:'34',start_time:'2018-06-20',end_time:'2018-06-22',status:2,doctor:'',patient_name:'',source_org_id:''}
		def change_data_report args={}
			data = []
      org_id = args[:org_id]
      start_time = args[:start_time] || (Time.new - 1.day).to_s(:db)
      end_time = args[:end_time] || Time.new.to_s(:db)
      status = args[:status]
      return {flag:false,:info=>"药店机构为空。"} if org_id.blank?
      sql = "SELECT  b.name as 'title' ,b.specifications as 'specification',b.firm,sum(b.quantity) as 'total_qty',b.unit,b.price,round(sum(b.net_amt),2) as 'total_amount',GROUP_CONCAT(a.id) as 'ids' FROM orders_orders a INNER JOIN orders_order_details b on a.id= b.order_id where a.target_org_id=#{args[:org_id]}"
      sql.concat(" and doctor=#{args[:doctor]}") unless args[:doctor].blank?
      sql.concat(" and patient_name=#{args[:patient_name]}") unless args[:patient_name].blank?
      sql.concat(" and source_org_id=#{args[:source_org_id]}") unless args[:source_org_id].blank?
      case  args[:status].to_s
      when '1'#未付款
       sql.concat(" and payment_type = 2 and status=#{args[:status]} ")
      when '2'#已付款
       sql.concat(" and status=#{args[:status]} ")
      else
       sql.concat(" and ((payment_type = 2 and status=1) or status=2) ")
      end
      sql.concat(" and a.created_at BETWEEN '#{start_time}' AND '#{end_time}' GROUP BY  b.name,b.specifications,b.firm,b.unit,b.price;")
      p sql
      result = Orders::Order.find_by_sql(sql)
      JSON.parse(result.to_json)
		end


    # 处方药品汇总(发药/退药)[根据医院或发药人](目前实时统计)  先不考虑其他药房可退药情况
    # => args = {status:"",hospital:nil,detail:nil,delivery_name:nil,factory_name:false,start_time:nil,end_time:nil,org_id:irg_id,current_user:current_user} status:表示发药、退药，hospital：是否是按医院分组，detail：是否查看明细，delivery_name：是否按发药人分组,是否要按生成厂家显示
    def drug_report args = {}
      begin
        org_id = args[:org_id]
        status = args[:status]
        tbh ='pre_headers' # "iph_#{org_id}"
        tbd = 'pre_details' # "ipd_#{org_id}"
        return {flag:false,:info=>"药店机构为空。"} if org_id.blank?
        start_time = args[:start_time] || (Time.new - 1.day).to_s(:db)
        end_time = args[:end_time] || Time.new.to_s(:db)
        org_display = args[:hospital].blank? ? "": ",a.org_display" 
        author_name = args[:detail].blank? ? "": ",a.author_name"  
        factory_name = args[:factory_name].blank? ? "": ",b.factory_name"  
        opt_name = status.blank? ? "": (status=="4" ? ",a.delivery_name": ",a.return_name")
        c_d = status.blank? ? " and (a.status=4 or a.status=8 ) and a.delivery_at BETWEEN '#{start_time}' AND '#{end_time}' or a.return_at BETWEEN '#{start_time}' AND '#{end_time}'" : "and a.status=#{status} and "+(status=='4' ? 'a.delivery_at ' : 'a.return_at ')+"BETWEEN '#{start_time}' AND '#{end_time}'"
        sql = "SELECT b.title,b.specification,#{factory_name},b.unit,b.price,SUM(b.qty) as 'total_qty', round(sum(b.amount),2) as 'total_amount'#{org_display}#{author_name}#{opt_name},GROUP_CONCAT(a.id) as 'ids' FROM #{tbh} a INNER JOIN #{tbd} b on a.id=b.header_id where a.drug_store_id=#{org_id} "+c_d+" GROUP BY b.title,b.specification,#{factory_name},b.unit,b.price#{org_display}#{author_name}#{opt_name};"
        result = Ims::PreHeader.find_by_sql(sql)
        JSON.parse(result.to_json)
      rescue Exception => e
        print e.message rescue "  e.messag----"
        print "============== 处方药品汇总 出错: " + e.backtrace.join("\n")
        result = {flag:false,:info=>"药店系统出错。"}
      end
    end


    # 报表查看明细 通过id查询
    def report_detail args={}
      org_id = args[:org_id]
      tbh ='pre_headers' # "iph_#{org_id}"
      tbd = 'pre_details' # "ipd_#{org_id}"
      ids = "("+args[:ids]+")"
      sql = "SELECT * FROM #{tbh} a INNER JOIN #{tbd} b on a.id=b.header_id WHERE a.id in #{ids}"
      result = Ims::PreHeader.find_by_sql(sql)
      JSON.parse(result.to_json)
    end

    # 针对医院的统计
    def hospital_report args = {}
      result = drug_report args
      data = result.group_by{|e| e["org_display"]}
      unless args[:detail].blank?
        data1 ={}
        data.map{|k,v| data1[k] = v.group_by{|e| e['author_name']}}
        data = data1
      end
      return data
    end

    # 针对发药人的统计
    def name_report args = {}
      result = drug_report args
      result.group_by{|e| e["delivery_name"]}
    end

    # 针对医院及发药人的
    def hospital_and_name args = {}
      result = drug_report args
      data = {}
      if args[:type]=="hospital_and_name"
        groups= result.group_by{|e| e["org_display"]}
        groups.map{|k,v| data[k] = v.group_by{|e| e['delivery_name']}}
        return data
      end
      groups= result.group_by{|e| e["delivery_name"]}
      groups.map{|k,v| data[k] = v.group_by{|e| e['org_display']}}
      return data
    end

    # 针对厂家的
    def drug_by_fact args = {}
      result = drug_report args
      result.group_by{|e| e["factory_name"]}
    end


	end

end

#encoding:utf-8
# => 药店-报表
class Ims::Report
	class << self

		# => 药店药品销售情况
		# => [当前机构、来源机构、发药时间区间、发药人、]
		def sale_report args = {}
			
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
		def change_data_report
			data = []
      return {flag:false,:info=>"药店机构为空。"} if args[:org_id].blank?
      # sql =" SELECT * FROM orders_orders where target_org_id = #{args[:org_id]}"
      query ="target_org_id = #{args[:org_id]} and created_at between '2018-06-17' and date_add('2018-06-19',interval 1 day)"
      query.concat(" and doctor=#{args[:doctor]}") unless args[:doctor].blank?
      query.concat(" and patient_name=#{args[:patient_name]}") unless args[:patient_name].blank?
      query.concat(" and source_org_id=#{args[:source_org_id]}") unless args[:source_org_id].blank?
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
      orders = Orders::Order.where(query)
      orders.each do |order|

      end

		end

	end

end

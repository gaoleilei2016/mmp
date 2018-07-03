module ::Hospital::Interface
  # => 根据电话号获取处方单
  def self.get_prescriptions_by_phone(phone,status='')
    cur_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    sql = "SELECT a.* FROM hospital_prescriptions a INNER JOIN  hospital_encounters b on a.encounter_id=b.id WHERE b.phone=#{phone} AND a.effective_end>='#{cur_time}'"
    status.present? && sql.concat(" AND a.status = #{status}")
    ::Hospital::Prescription.find_by_sql(sql)
  end

  def self.get_prescriptions_by_phone_with_sort(phone,page = 1,per = 5, sort = "DESC")
    sql = "SELECT a.* FROM hospital_prescriptions a INNER JOIN  hospital_encounters b on a.encounter_id=b.id WHERE b.phone=#{phone}"
    sort == "DESC" ? "DESC" : "ASC"
    page = page.to_i
    per = per.to_i
    offset = (page-1) * per
    sql.concat(" ORDER BY a.`created_at` #{sort} LIMIT #{per} OFFSET #{offset}")
    ::Hospital::Prescription.find_by_sql(sql)
  end

  def self.get_prescriptions_count_by_phone(phone)
    sql = "SELECT a.* FROM hospital_prescriptions a INNER JOIN  hospital_encounters b on a.encounter_id=b.id WHERE b.phone=#{phone}"
    ::Hospital::Prescription.find_by_sql(sql).count
  end



  # 根据处方ids 获取处方信息
  def self.get_prescriptions_by_ids(prescription_ids)
    ret = {}
    prescription_ids.each do |_prescription_id|
      ret[_prescription_id] = ::Hospital::Prescription.find(_prescription_id).to_web_front
    end
    return ret
  end

  def self.get_not_read_prescriptions_by_phone(phone)
    sql = "SELECT a.* FROM hospital_prescriptions a INNER JOIN  hospital_encounters b on a.encounter_id=b.id WHERE b.phone=#{phone} AND a.is_read=0"
    ::Hospital::Prescription.find_by_sql(sql)
  end



#   attrs = { 
#   target_org_ii:'目标药房的名称和机构',
#   target_org_name:'目标药房的名称和机构',
#   source_org_ii:'来源的医院名称和ii',
#   source_org_name:'来源的医院名称和ii',
#   order_code:'订单号',
#   perscript_id:'处方id',
#   user_id:'用户id',
#   details:[
#     name:'名称',
#     item_id:'商品id',
#     unit:'2',
#     quantity:'1',
#     price:'单价',
#     specifications:'规格',
#     dosage:'剂型'
#   ]
# }
  # 处方转账单
  def self.prescription_to_order(prescription_ids)
    ret = {}
    prescription_ids.each do |prescription_id|
      cur_prescription = ::Hospital::Prescription.find(prescription_id)
      cur_org = cur_prescription.organization
      cur_orders = cur_prescription.orders
      attrs = { 
        target_org_id: cur_prescription.drug_store&.id,
        target_org_name: cur_prescription.drug_store&.name,
        source_org_id: cur_org.id,
        source_org_name: cur_org.name,
        order_code: nil,
        perscript_id: cur_prescription.id,
        user_id: cur_prescription.encounter.person.user&.id,
        person_id: cur_prescription.encounter.person.id,
        doctor: cur_prescription.doctor&.name
      }
      details = cur_orders.map do |_order|
        {
          name: _order.title,
          item_id: _order.serialno,
          unit: _order.unit,
          quantity: _order.total_quantity,
          price: _order.price,
          specifications: _order.specification,
          dosage:'剂型'
        }
      end
      attrs.merge!(details: details)
      ret[prescription_id] = attrs
    end
    return ret
  end

  # 处方转账单  处方id是同一个就诊的处方id
  def self.prescription_to_order2(prescription_ids)
    ret = {details: {}}
    prescription_ids.each_with_index do |prescription_id, index|
      cur_prescription = ::Hospital::Prescription.find(prescription_id)
      cur_orders = cur_prescription.orders
      if index == 0
        cur_org = cur_prescription.organization
        ret[:hospital_id] = cur_org.id
        ret[:hospital_name] = cur_org.name
        ret[:doctor] = cur_prescription.doctor&.name
        ret[:user_id] = cur_prescription.encounter.person.user&.id
        ret[:person_id] = cur_prescription.encounter.person.id
        ret[:person_name] = cur_prescription.encounter.person.name
        ret[:phone] = cur_prescription.encounter.phone # 当前就诊的电话号
        ret[:patient_sex] = cur_prescription.encounter.gender_display # 当前就诊的性别
        ret[:patient_age] = cur_prescription.encounter.age # 当前就诊年龄
        ret[:patient_iden] = cur_prescription.encounter.iden # 当前就诊的身份证
      end
      prescription_details = cur_orders.map do |_order|
        {
          name: _order.title,
          item_id: _order.serialno,
          unit: _order.unit,
          quantity: _order.total_quantity,
          price: _order.price,
          specifications: _order.specification,
          firm: _order.factory_name,
          dosage:'剂型',
          img_path: _order.dict_medication&.picture
        }
      end
      ret[:details][prescription_id] = prescription_details
    end
    return ret
  end
end
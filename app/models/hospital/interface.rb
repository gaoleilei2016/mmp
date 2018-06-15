module ::Hospital::Interface
  # => 根据电话号获取处方单
  def self.get_prescription(phone)
    ::Hospital::Prescription.find_by_sql("SELECT a.* FROM hospital_prescriptions a INNER JOIN  hospital_encounters b on a.encounter_id=b.id WHERE b.phone=#{phone}")
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
      end
      prescription_details = cur_orders.map do |_order|
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
      ret[:details][prescription_id] = prescription_details
    end
    return ret
  end
end
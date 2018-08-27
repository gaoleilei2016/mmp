class Hospital::Order < ApplicationRecord

  belongs_to :encounter, class_name: '::Hospital::Encounter', foreign_key: 'encounter_id', optional: true
  # has_one :dict_medication, class_name: '::Dict::Medication', foreign_key: 'serialno' 

  belongs_to :prescription, class_name: '::Hospital::Prescription', foreign_key: 'prescription_id', optional: true
  belongs_to :author, class_name: '::User', foreign_key: 'author_id', optional: true
  belongs_to :mtemplate, class_name: '::Hospital::Sets::Mtemplate', foreign_key: 'mtemplate_id', optional: true
  # order_type 医嘱类型 1 药品医嘱

  def initialize args = {}
    super args
    self.status = 0
    self.type_type = 'instance'
  end


  def dict_medication
    ::Dict::Medication.find(self.serialno) rescue nil
  end

  def to_web_front_with_photo
    ret = {
      id: self.id,
      serialno: self.serialno,
      picture: self.dict_medication&.picture,
      title: self.title,
      specification: self.specification,
      single_qty: {
        value: self.single_qty_value,
        unit: self.single_qty_unit
      },
      dose: {
        value:self.dose_value,
        unit: self.dose_unit
      },
      route:{
        code: self.route_code,
        display: self.route_display
      },
      frequency:{
        code: self.frequency_code,
          display: self.frequency_display
      },
      course_of_treatment:{
        value: self.course_of_treatment_value,
        unit: self.course_of_treatment_unit
      },
      formul: {
        code: self.formul_code,
        display: self.formul_display
      },
      total_quantity: self.total_quantity,
      unit: self.unit,
      price: self.price,
      total_price: self.price * self.total_quantity,
      note: self.note,
      status: self.status,
      order_type: self.order_type,
      encounter_id: self.encounter_id,
      author: {
        id: self.author.id,
        display: self.author.name
      },
      factory_name: self.factory_name,
      base_unit: self.base_unit,
      mul: self.mul,
      measure_val: self.measure_val,
      measure_unit: self.measure_unit,
      type_type: self.type_type
    }
  end

  def to_web_front
    ret = {
      id: self.id,
      serialno: self.serialno,
      title: self.title,
      specification: self.specification,
      single_qty: {
        value: self.single_qty_value,
        unit: self.single_qty_unit
      },
      dose: {
        value:self.dose_value,
        unit: self.dose_unit
      },
      route:{
        code: self.route_code,
        display: self.route_display
      },
      frequency:{
        code: self.frequency_code,
          display: self.frequency_display
      },
      course_of_treatment:{
        value: self.course_of_treatment_value,
        unit: self.course_of_treatment_unit
      },
      formul: {
        code: self.formul_code,
        display: self.formul_display
      },
      total_quantity: self.total_quantity,
      unit: self.unit,
      price: self.price,
      total_price: self.price * self.total_quantity,
      note: self.note,
      status: self.status,
      order_type: self.order_type,
      encounter_id: self.encounter_id,
      author: {
        id: self.author.id,
        display: self.author.name
      },
      factory_name: self.factory_name,
      base_unit: self.base_unit,
      mul: self.mul,
      measure_val: self.measure_val,
      measure_unit: self.measure_unit,
      type_type: self.type_type
    }
  end

  class<<self
    def can_to_prescription?(order_ids)
      cur_order_status = ::Hospital::Order.find(order_ids).map { |e| e.status  }
      cur_order_status.uniq! 
      p cur_order_status
      if cur_order_status.size == 1 && cur_order_status[0] == 0 # 还是新建状态的医嘱就能创建处方
        true
      else
        false
      end
    end

    def copy_orders(order_ids, encounter_id, cur_user)
      cur_encounter = ::Hospital::Encounter.find(encounter_id)
      cur_orders = ::Hospital::Order.find(order_ids)
      ::ActiveRecord::Base.transaction do 
        cur_orders.each do |_order|
          # 三方面复制  复制药品使用信息  复制当前药品的价格  置空相关医嘱和人相关的信息
          # 查询当前药品使用信息
          cur_medication = ::Dict::Medication.find(_order.serialno)
          next unless cur_medication.can_create?
          medication_info = cur_medication.to_order_info
          new_order_args = {
              single_qty_value: _order.single_qty_value,
              single_qty_unit: _order.single_qty_unit,
              dose_value: _order.dose_value,
              dose_unit: _order.dose_unit,
              route_code: _order.route_code,
              route_display: _order.route_display,
              frequency_code: _order.frequency_code,
              frequency_display: _order.frequency_display,
              course_of_treatment_value: _order.course_of_treatment_value,
              course_of_treatment_unit: _order.course_of_treatment_unit,
              total_quantity: _order.total_quantity,
              order_type: _order.order_type,
              status: 0,
              encounter_id: encounter_id,
              author_id: cur_user.id,
              prescription_id: nil,
              type_type: _order.type_type
          }
          new_order_args.merge!(medication_info)
          new_order = ::Hospital::Order.create!(new_order_args)
        end
      end
    end

    def to_template_order(order_ids, mtemplate_id, cur_user)
      cur_orders = ::Hospital::Order.find(order_ids)
      ::ActiveRecord::Base.transaction do 
        cur_orders.each do |_order|
          if _order.type_type == "template"
            # 如果是模板医嘱就直接创建关系  不做复制
            _order.mtemplate_id = mtemplate_id
            _order.save!
            next
          end
          # 三方面复制  复制药品使用信息  复制当前药品的价格  置空相关医嘱和人相关的信息
          # 查询当前药品使用信息
          cur_medication = ::Dict::Medication.find(_order.serialno)
          raise "创建失败  有药品不能使用" unless cur_medication.can_create?
          medication_info = cur_medication.to_order_info
          new_order_args = {
              single_qty_value: _order.single_qty_value,
              single_qty_unit: _order.single_qty_unit,
              dose_value: _order.dose_value,
              dose_unit: _order.dose_unit,
              route_code: _order.route_code,
              route_display: _order.route_display,
              frequency_code: _order.frequency_code,
              frequency_display: _order.frequency_display,
              course_of_treatment_value: _order.course_of_treatment_value,
              course_of_treatment_unit: _order.course_of_treatment_unit,
              total_quantity: _order.total_quantity,
              order_type: _order.order_type,
              status: 0,
              author_id: cur_user.id,
              mtemplate_id: mtemplate_id,
              type_type:"template"
          }
          new_order_args.merge!(medication_info)
          new_order = ::Hospital::Order.create!(new_order_args)
        end
      end
    end

    def can_create?(encounter_id)
      cur_encounter = ::Hospital::Encounter.find(encounter_id) rescue nil
      return {flag: false, info:"无效就诊id"}if cur_encounter.nil?
      # 判断是否存在诊断  存在诊断就能创建 医嘱
      if cur_encounter.diagnoses.present?
        return {flag: true, info: "success"}
      else
        return {flag: false, info: "请先下诊断"}
      end
    end
  end
end
#encoding:utf-8
# => 药店-处方明细
class Ims::PrescriptionDetail < ApplicationRecord
  belongs_to :prescription, class_name: '::Ims::PrescriptionHeade', foreign_key: 'prescription_id', optional: true


	# :serialno                         # => 药品主键
	# :title                            # => 药品名称
	# :specification                    # => 药品规格
	# :single_qty_value                 # => 单次药品的数量
	# :single_qty_unit                  # => 单次药品的数量单位
	# :dose_value                       # => 单次药品的剂量
	# :dose_unit                        # => 单次药品的剂量单位
	# :route_value                      # => 使用途径
	# :route_unit                       # => 使用途径
	# :frequency_code                   # => 频次bid
	# :frequency_display                # => 频次(一天两次、、、)
	# :course_of_treatment_value        # => 疗程
	# :course_of_treatment_unit         # => 疗程
	# :formul_code                      # => 剂型code
	# :formul_display                   # => 剂型名称
	# :qty                              # => 数量
	# :send_qty                         # => 发药数量
	# :return_qty                       # => 退药数量
	# :unit                             # => 单位
	# :price                            # => 单价
	# :amount                           # => 金额
	# :note                             # => 备注
	# :status                           # => 状态
	# :order_type                       # => 医嘱类型(1:药品医嘱...)
	# :encounter_id                     # => 就诊id
	# :author_id                        # => 医生id
	# :author_name                      # => 医生姓名
	# :factory_name                     # => 生成厂商
	# :base_unit                        # => 基本单位
	# :mul                              # => 销售/基本单位的倍率
	# :purch_mul                        # => 采购/基本单位的倍率
	# :measure_val                      # => 最小计量
	# :measure_unit                     # => 最小计量单位
	# :type_type                        # => 
	# :status                           # => 状态
	# :hospital_prescription_order_id   # => 关联医院处方明细id
end

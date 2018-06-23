#encoding:utf-8
# => 药店-处方明细
class Ims::PreDetail < ApplicationRecord
  belongs_to :prescription, class_name: '::Ims::PreHeade', foreign_key: 'header_id', optional: true

# rails generate scaffold Ims::PreDetail 
# drug_id:integer                              # => 药品主键 
# title:string                                 # => 药品名称 
# specification:string                         # => 药品规格 
# single_qty_value:string                      # => 单次药品的数量 
# single_qty_unit:string                       # => 单次药品的数量单位 
# dose_value:string                            # => 单次药品的剂量 
# dose_unit:string                             # => 单次药品的剂量单位 
# route_code:string                            # => 使用途径 
# route_display:string                            # => 使用途径 
# frequency_code:string                        # => 频次bid 
# frequency_display:string                     # => 频次(一天两次、、、) 
# course_of_treatment_value:string             # => 疗程 
# course_of_treatment_unit:string              # => 疗程 
# formul_code:string                           # => 剂型code 
# formul_display:string                        # => 剂型名称 
# qty:float                                    # => 数量 
# send_qty:float                               # => 发药数量 
# return_qty:float                             # => 退药数量 
# unit:string                                  # => 单位 
# price:string                                 # => 单价 
# amount:float                                 # => 金额 
# note:string                                  # => 备注 
# order_type:string                            # => 医嘱类型(1:药品医嘱...) 
# encounter_id:integer                         # => 就诊id 
# author_id:integer                            # => 医生id 
# author_name:string                           # => 医生姓名 
# factory_name:string                          # => 生成厂商 
# base_unit:string                             # => 基本单位 
# sale_unit:string                             # => 销售单位
# purch_unit:string                            # => 采购单位
# mul:string                                   # => 销售/基本单位的倍率 
# purch_mul:string                             # => 采购/基本单位的倍率 
# measure_val:string                           # => 最小计量 
# measure_unit:string                          # => 最小计量单位 
# type_type:string                             # =>  
# status:integer                               # => 状态 
# hospital_prescription_detail_id:integer      # => 关联医院处方明细id  
# ori_detail_id:integer												 # => 原来的detail_id(退药)
# header_id:integer                            # => 关联的header_id
end

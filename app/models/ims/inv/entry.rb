#encoding:utf-8
# => 药店-总账明细表(正确的总账明细应该是所有数据之和是库存)
class Ims::Inv::Entry < ApplicationRecord


# rails generate scaffold Ims::Inv::Entry org_id:integer medicine_id:integer name:string spec:string formul_name:string entry_type:string pt_code:string code:string unit:string price:float mul:string batch:string location_id:string location_name:string quantity:float amount:float source_id:string source_name:string document_id:string document_code:string document_line_id:string note:string operater:string operater_id:string operat_at:datetime patient_name:string posting_on:datetime created_at:datetime updated_at:datetime
# bundle exec rake db:migrate

# id                     # 总账表ID 
# org_id                 # 组织机构id 
# medicine_id            # 药品ID 
# name                   # 通用名称 
# spec                   # 规格 
# formul_name            # 剂型名称 
# entry_type             # 总账类型(1:发药,2:退药) 
# pt_code                # 平台药品code 
# code                   # 药品code 
# unit                   # 单位 
# price                  # 价格 
# mul                    # 销售/基本单位的倍率 
# batch                  # 批号 
# location_id            # 药库id 
# location_name          # 药库名称 
# quantity               # 库存数量 
# amount                 # 金额 
# source_id              # 来源id(比如：某某某医院id) 
# source_name            # 来源名称(比如：某某某医院) 
# document_id            # 凭证id(比如：处方或订单id) 
# document_code          # 凭证编号(处方号或者订单号) 
# document_line_id       # 凭证明细id 
# note                   # 备注 
# operater               # 执行人 
# operater_id            # 执行人id 
# operat_at              # 执行时间 
# patient_name           # 患者名称 
# posting_on             # 过账时间 
# created_at             # 建立时间 
# updated_at             # 更新时间 

end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180623072746) do

  create_table "admin_hospital_pharmacys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "pharmacy_id"
    t.string "hospital_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_organizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type_code"
    t.string "name"
    t.string "jianpin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "yaofang_type"
    t.string "addr"
    t.float "lat", limit: 53
    t.float "lng", limit: 53
  end

  create_table "char2letter", primary_key: "PY", id: :string, limit: 1, collation: "utf8_general_ci", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=gbk" do |t|
    t.string "HZ", limit: 1, default: "", null: false
  end

  create_table "common_addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "use"
    t.string "type"
    t.string "province"
    t.string "city"
    t.string "country"
    t.string "township"
    t.string "street"
    t.string "house_number"
    t.string "post_code"
    t.string "detail"
    t.string "period_start"
    t.string "period_end"
    t.string "status"
    t.integer "master_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dictarea", primary_key: "serialno", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "序号" do |t|
    t.string "supcode", limit: 30, comment: "上级"
    t.string "code", limit: 30, null: false, comment: "编码"
    t.string "name", limit: 100, null: false, comment: "名称"
    t.string "py", limit: 50, comment: "拼音码"
    t.string "wb", limit: 50, comment: "五笔码"
    t.string "status", limit: 1, default: "A", comment: "状态(N: '新建'   A: '活动'   T: '停用')"
    t.index ["name", "py", "wb"], name: "idx_area_name"
  end

  create_table "dictdata", primary_key: "serialno", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "序号" do |t|
    t.string "ii_root", limit: 30, comment: "机构代码(查询包含空,和具体机构信息)"
    t.string "oid", limit: 30, comment: "字典识别码"
    t.string "code", limit: 30, null: false, comment: "编码"
    t.string "name", limit: 100, null: false, comment: "名称"
    t.integer "ordid", comment: "排序号(记得排序先让此列为首要排序)"
    t.string "py", limit: 50, comment: "拼音码"
    t.string "wb", limit: 50, comment: "五笔码"
    t.string "status", limit: 1, default: "N", comment: "状态(N: '新建'   A: '活动'   T: '停用')"
    t.index ["ii_root", "oid"], name: "idx_dict_iiroot"
    t.index ["name", "ordid", "py", "wb"], name: "idx_dict_names"
    t.index ["oid"], name: "idx_dict_oid"
  end

  create_table "dictdatagroup", primary_key: "serialno", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "序号" do |t|
    t.string "oid", limit: 30, comment: "字典识别码"
    t.string "name", limit: 100, null: false, comment: "名称"
    t.text "remark", comment: "备注"
    t.index ["oid"], name: "idx_dictgp_oid", unique: true
  end

  create_table "dictdisease", primary_key: "serialno", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "疾病字典表" do |t|
    t.string "codetype", limit: 6, comment: "代码类别(9:ICD9,10:ICD10)"
    t.string "ICD10", limit: 20, null: false, comment: "ICD10编码"
    t.string "ICD9", limit: 20, comment: "ICD9,ICD码"
    t.string "name", limit: 100, null: false, comment: "疾病名称"
    t.decimal "kind", precision: 18, comment: "疾病类别（用于临床医生站）"
    t.string "py", limit: 50, null: false, comment: "输入码"
    t.string "wb", limit: 50
    t.string "tjbm", limit: 10, comment: "其它统计码，目前是病案统计吗"
    t.string "fjbm", limit: 10, comment: "附加编码"
    t.decimal "sexlimit", precision: 1, default: "0", comment: "性别限制(0不限 1限男 2限女)"
    t.string "remarks", limit: 100, comment: "备注信息"
    t.index ["ICD10"], name: "ICD_idx", unique: true
    t.index ["name", "py", "wb"], name: "ICD_name"
  end

  create_table "dictmedicine", primary_key: "serialno", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "药品字典表" do |t|
    t.string "ecode", limit: 20, comment: "易用码"
    t.string "effect_code", limit: 20, comment: "药品功效编码"
    t.string "name", limit: 120, null: false, comment: "通用名称"
    t.string "common_name", limit: 120, comment: "商品名称"
    t.string "alias_name", limit: 80, comment: "首选别名"
    t.string "py", limit: 60, null: false, comment: "通用名拼音码"
    t.string "wb", limit: 60, comment: "通用名五笔码"
    t.string "common_py", limit: 60, comment: "商品名拼音码"
    t.string "common_wb", limit: 60, comment: "商品名五笔码"
    t.string "alias_py", limit: 40, comment: "别名拼音码"
    t.string "alias_wb", limit: 40, comment: "别名五笔码"
    t.string "spec", limit: 20, comment: "规格"
    t.string "formul_code", limit: 8, comment: "剂型代码"
    t.string "formul_name", limit: 20, comment: "剂型名称"
    t.string "usedescribe", limit: 80, comment: "用法用量描述"
    t.string "measure_unit", limit: 30, comment: "最小计量单位"
    t.decimal "measure_val", precision: 10, scale: 2, comment: "最小计量值"
    t.string "base_unit", limit: 30, comment: "基本单位"
    t.string "purch_unit", limit: 30, comment: "采购单位"
    t.string "unit", limit: 30, comment: "销售单位"
    t.decimal "mul", precision: 10, scale: 2, comment: "销售/基本单位的倍率"
    t.decimal "purch_mul", precision: 10, scale: 2, comment: "采购/基本单位的倍率"
    t.decimal "purch_price", precision: 12, scale: 4, comment: "采购价格"
    t.decimal "price", precision: 12, scale: 4, comment: "销售价格"
    t.string "kindcode", limit: 4, comment: "药品分类"
    t.string "kindname", limit: 20, comment: "分类名称"
    t.string "licensenum", limit: 30, comment: "批准文号"
    t.string "bar_code", limit: 30, comment: "条形码"
    t.string "produce_code", limit: 8, comment: "厂家编码"
    t.string "produce_name", limit: 60, comment: "厂家名称"
    t.text "instruction", comment: "说明书"
    t.string "bxkind", limit: 20, comment: "报销类型"
    t.binary "picture", comment: "药品图片"
    t.string "status", limit: 1, default: "A", comment: "状态"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "建立时间"
    t.timestamp "updated_at", comment: "最后修改时间"
    t.string "coperator", limit: 20, comment: "建立人"
    t.string "uoperator", limit: 20, comment: "最后修改人员"
  end

  create_table "health_cloud_ws_sys", primary_key: "sid", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "company", limit: 50
    t.string "strprgid", limit: 50, null: false
    t.string "strprgpws", limit: 50, null: false
  end

  create_table "hospital_diagnoses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "code", limit: 20, comment: "诊断编码"
    t.string "display", limit: 100, null: false, comment: "诊断名称"
    t.string "system", limit: 50, comment: "诊断编码系统  现在只支持ICD10"
    t.string "status", limit: 1, default: "A", comment: "诊断状态 A 未确诊  E 已确诊"
    t.integer "rank", limit: 1, comment: "诊断序号"
    t.bigint "encounter_id", comment: "就诊id ( Hospital::Encounter )"
    t.bigint "doctor_id", null: false, comment: "医生id（User）"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
    t.bigint "prescription_id", comment: "处方id ( Hospital::Prescription )"
    t.string "note", comment: "诊断备注"
    t.datetime "fall_ill_at", comment: "发病时间"
    t.integer "type_code", comment: "诊断类型 0 主要诊断  1 次要诊断"
    t.string "type_display", limit: 10, comment: "诊断类型名称"
  end

  create_table "hospital_encounters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "iden", limit: 18, comment: "身份证号"
    t.string "name", limit: 60, null: false, comment: "姓名"
    t.string "name_jp", limit: 60, comment: "姓名简拼"
    t.string "name_wb", limit: 60, comment: "姓名五笔"
    t.datetime "birth_date", comment: "出生日期"
    t.integer "age", limit: 1, null: false, comment: "就诊年龄", unsigned: true
    t.string "gender_code", limit: 2, null: false, comment: "性别编码"
    t.string "gender_display", limit: 6, null: false, comment: "性别编码名称"
    t.string "occupation_code", limit: 2, comment: "职业编码"
    t.string "occupation_display", limit: 40, comment: "职业编码名称"
    t.string "phone", limit: 11, null: false, comment: "手机号"
    t.string "address", comment: "就诊时填写的地址  现居地址"
    t.string "unit_name", comment: "工作单位名称（或者学校等）"
    t.string "ua_address", comment: "单位地址（或者学校等）"
    t.string "unit_phone", limit: 20, comment: "单位联系电话"
    t.string "contact_name", limit: 60, comment: "联系人名称"
    t.string "contact_phone", limit: 20, comment: "联系人电话"
    t.bigint "hospital_oid", null: false, comment: "医院 机构id"
    t.string "hospital_name", null: false, comment: "医院名称"
    t.string "patient_domain_code", limit: 2, comment: "门诊或住院编码"
    t.string "patient_domain_display", limit: 10, collation: "latin5_turkish_ci", comment: "门诊或住院编码名称"
    t.string "patient_no", limit: 10, default: "", null: false, comment: "就诊号"
    t.datetime "started_at", comment: "就诊时间"
    t.datetime "created_at", null: false, comment: "数据创建时间"
    t.datetime "updated_at", null: false, comment: "数据更新时间"
    t.string "nation_code", limit: 4, comment: "民族编码"
    t.string "nation_display", limit: 40, comment: "民族编码名称"
    t.string "blood_code", limit: 2, comment: "血型编码"
    t.string "blood_display", limit: 20, comment: "血型编码名称"
    t.bigint "drugstore_location_id", comment: "药店id"
    t.string "marriage_code", limit: 2, comment: "婚姻编码"
    t.string "marriage_display", limit: 20, comment: "婚姻编码名称"
    t.decimal "height", precision: 6, scale: 2, comment: "身高"
    t.decimal "weight", precision: 6, scale: 2, comment: "体重"
    t.bigint "person_id", comment: "实体人 Person id"
    t.bigint "author_id", null: false, comment: "User 接诊医生"
  end

  create_table "hospital_irritabilities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "code", limit: 10, comment: "过敏编码"
    t.string "display", limit: 40, null: false, comment: "过敏编码名称"
    t.string "system", limit: 40, comment: "过敏编码系统"
    t.string "status", limit: 1, comment: "过敏状态"
    t.datetime "period_start", comment: "过敏开始时间"
    t.bigint "data_entry_id", null: false, comment: "数据录入人 User"
    t.bigint "person_id", null: false, comment: "过敏所属人 Person"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
  end

  create_table "hospital_orders", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "serialno"
    t.string "title"
    t.string "specification"
    t.float "single_qty_value", limit: 24
    t.string "single_qty_unit"
    t.float "dose_value", limit: 24
    t.string "dose_unit"
    t.string "route_code"
    t.string "route_display"
    t.string "frequency_code"
    t.string "frequency_display"
    t.integer "course_of_treatment_value"
    t.string "course_of_treatment_unit", default: "天"
    t.float "total_quantity", limit: 24
    t.string "unit"
    t.float "price", limit: 24
    t.string "note"
    t.integer "status", default: 0
    t.integer "order_type", default: 1
    t.integer "encounter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prescription_id"
    t.integer "author_id"
    t.string "formul_code"
    t.string "formul_display"
    t.integer "mtemplate_id"
    t.string "factory_name"
    t.string "base_unit"
    t.decimal "mul", precision: 10
    t.decimal "measure_val", precision: 10
    t.string "measure_unit"
    t.string "type_type", default: "Instance"
    t.bigint "org_id"
  end

  create_table "hospital_prescriptions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=gb2312", comment: "处方头信息表" do |t|
    t.integer "organization_id"
    t.integer "status", limit: 1, default: 1, comment: "处方状态:0 未审核,  1:已审核   2:待收费   3:已收费   4:已发药   8:已退药  9:已退费"
    t.string "note", collation: "utf8_general_ci"
    t.string "type_code", collation: "utf8_general_ci"
    t.integer "bill_id"
    t.string "confidentiality_code", collation: "utf8_general_ci"
    t.integer "doctor_id"
    t.integer "encounter_id"
    t.datetime "effective_start"
    t.datetime "effective_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type_display", collation: "utf8_general_ci", comment: "处分类型名称"
    t.string "confidentiality_display", collation: "utf8_general_ci", comment: " 权限描述"
    t.integer "prescription_no", comment: "处方号"
    t.boolean "specialmark", default: false, comment: "特殊处方标记"
    t.integer "drug_store_id"
    t.integer "order_id"
    t.string "tookcode", limit: 20, comment: "取药码"
    t.integer "author_id"
    t.string "auditor_id"
    t.string "auditor_display"
    t.datetime "audit_at"
    t.string "abandonor_id"
    t.string "abandonor_display"
    t.datetime "abandon_at"
    t.string "delivery_id"
    t.string "delivery_display"
    t.datetime "delivery_at"
    t.integer "create_bill_opt_id"
    t.string "create_bill_opt_display"
    t.datetime "bill_at"
    t.integer "charger_id"
    t.string "charger_display"
    t.datetime "charge_at"
    t.integer "return_charge_opt_id"
    t.string "return_charge_opt_display"
    t.datetime "return_charge_at"
    t.string "ceshi"
  end

  create_table "hospital_sets_departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "org_id", null: false, comment: "机构id"
    t.string "name", limit: 20, default: "", null: false, comment: "科室名称"
    t.string "jianpin", limit: 20, default: "", comment: "科室简称"
    t.string "status", limit: 2, default: "", null: false, comment: "状态 N 新建   A 活动  O作废"
    t.string "search_str", default: "", comment: "模糊查询字段"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
    t.string "note", comment: "科室备注"
  end

  create_table "hospital_sets_inis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean "enable_print_pres", default: false, comment: "是否启用处方打印 1是true  0是false"
    t.integer "uoperator_id", null: false, comment: "最后更新人 User.id"
    t.text "print_pres_html", comment: "打印模板  写了触发器"
    t.integer "org_id", null: false, comment: "机构id"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
  end

  create_table "hospital_sets_mtemplates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "org_id", null: false, comment: "机构id"
    t.string "status", limit: 1, null: false, comment: "状态  新建N   默认A 可用  O废弃"
    t.string "title", limit: 100, null: false, comment: "模板名称"
    t.string "note", comment: "模板备注"
    t.string "sharing_scope_code", limit: 1, null: false, comment: "共享代码"
    t.string "sharing_scope_display", limit: 20, null: false, comment: "共享名称"
    t.string "disease_code", limit: 20, null: false, comment: "病种代码"
    t.string "disease_display", limit: 100, null: false, comment: "病种名称"
    t.bigint "author_id", null: false, comment: "作者id"
    t.string "author_display", limit: 50, null: false, comment: "作者名称"
    t.bigint "location_id", null: false, comment: "科室id"
    t.string "location_display", limit: 60, null: false, comment: "科室名称"
    t.string "search_str", comment: "查询模糊字段"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
  end

  create_table "ims_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "org_ii", comment: "组织机构代码"
    t.string "org_name", comment: "组织机构名称"
    t.string "source_org_ii", comment: "来源机构"
    t.string "source_org_name", comment: "来源机构名称"
    t.string "target_org_ii", comment: "目标机构代码"
    t.string "target_org_name", comment: "目标机构名称"
    t.string "patient_order_id", comment: "患者订单id"
    t.string "order_code", comment: "订单号"
    t.string "author_name", comment: "开单医生"
    t.string "patient_name", comment: "患者姓名"
    t.integer "repeat_number", default: 1, comment: "中药副数"
    t.float "total_amount", limit: 24, default: 0.0, comment: "总金额"
    t.string "search_name", comment: "搜索名称（患者名称、简拼、五笔、单号、条形码、二维码、验证码）"
    t.string "note", comment: "备注信息"
    t.bigint "operater_id"
    t.string "operater_name", comment: "执行人"
    t.datetime "operat_at", comment: "执行时间"
    t.string "ori_id", comment: "原单id（退药的情况）"
    t.string "ori_code", comment: "原单单号（退药情况）"
    t.boolean "this_returned", default: false, comment: "该单是否已退"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
  end

  create_table "ims_pre_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "drug_id"
    t.string "title"
    t.string "specification"
    t.string "single_qty_value"
    t.string "single_qty_unit"
    t.string "dose_value"
    t.string "dose_unit"
    t.string "route_code"
    t.string "route_display"
    t.string "frequency_code"
    t.string "frequency_display"
    t.string "course_of_treatment_value"
    t.string "course_of_treatment_unit"
    t.string "formul_code"
    t.string "formul_display"
    t.float "qty", limit: 24
    t.float "send_qty", limit: 24
    t.float "return_qty", limit: 24
    t.string "unit"
    t.string "price"
    t.float "amount", limit: 24
    t.string "note"
    t.string "order_type"
    t.integer "encounter_id"
    t.integer "author_id"
    t.string "author_name"
    t.string "factory_name"
    t.string "base_unit"
    t.string "sale_unit"
    t.string "purch_unit"
    t.string "mul"
    t.string "purch_mul"
    t.string "measure_val"
    t.string "measure_unit"
    t.string "type_type"
    t.integer "status"
    t.integer "hospital_prescription_detail_id"
    t.integer "ori_detail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ims_pre_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "prescription_no"
    t.string "note"
    t.string "type_code"
    t.string "type_name"
    t.string "confidentiality_code"
    t.string "confidentiality_name"
    t.string "name"
    t.string "gender_code"
    t.string "gender_name"
    t.string "age"
    t.datetime "birth_date"
    t.string "iden"
    t.string "occupation_code"
    t.string "occupation_name"
    t.string "phone"
    t.string "address"
    t.integer "source_org_id"
    t.string "source_org_name"
    t.string "patient_no"
    t.integer "author_id"
    t.string "author_name"
    t.integer "auditor_id"
    t.string "auditor_name"
    t.datetime "audit_at"
    t.integer "charger_id"
    t.string "charger_name"
    t.datetime "charge_at"
    t.integer "encounter_loc_id"
    t.string "encounter_loc_name"
    t.float "total_amount", limit: 24
    t.integer "delivery_id"
    t.string "delivery_name"
    t.integer "delivery_org_id"
    t.string "delivery_org_name"
    t.datetime "delivery_at"
    t.integer "return_id"
    t.string "return_name"
    t.integer "return_org_id"
    t.string "return_org_name"
    t.datetime "return_at"
    t.integer "drug_store_id"
    t.string "drug_store_name"
    t.datetime "effective_start"
    t.datetime "effective_end"
    t.string "diagnoses"
    t.string "specialmark"
    t.string "status"
    t.integer "order_id"
    t.string "order_code"
    t.datetime "order_at"
    t.integer "create_bill_opt_id"
    t.string "create_bill_opt_name"
    t.datetime "hospital_prescription_at"
    t.integer "hospital_prescription_id"
    t.boolean "is_return"
    t.integer "ori_id"
    t.string "ori_code"
    t.string "tookcode"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ims_prescription_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "drug_id"
    t.string "title"
    t.string "specification"
    t.string "single_qty_value"
    t.string "single_qty_unit"
    t.string "dose_value"
    t.string "dose_unit"
    t.string "route_value"
    t.string "route_unit"
    t.string "frequency_code"
    t.string "frequency_display"
    t.string "course_of_treatment_value"
    t.string "course_of_treatment_unit"
    t.string "formul_code"
    t.string "formul_display"
    t.float "qty", limit: 24
    t.float "send_qty", limit: 24
    t.float "return_qty", limit: 24
    t.string "unit"
    t.string "price"
    t.float "amount", limit: 24
    t.string "note"
    t.string "status"
    t.string "order_type"
    t.string "encounter_id"
    t.string "author_id"
    t.string "author_name"
    t.string "factory_name"
    t.string "base_unit"
    t.string "mul"
    t.string "measure_val"
    t.string "measure_unit"
    t.string "type_type"
    t.integer "hospital_prescription_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ims_prescription_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "prescription_no"
    t.string "note"
    t.string "type_code"
    t.string "type_name"
    t.string "confidentiality_code"
    t.string "confidentiality_name"
    t.string "name"
    t.string "gender_code"
    t.string "gender_name"
    t.string "age"
    t.datetime "birth_date"
    t.string "iden"
    t.string "occupation_code"
    t.string "occupation_name"
    t.string "phone"
    t.string "address"
    t.string "org_id"
    t.string "org_display"
    t.string "patient_no"
    t.string "author_id"
    t.string "author_display"
    t.string "encounter_loc_id"
    t.string "encounter_loc_display"
    t.float "total_amount", limit: 24
    t.string "orders"
    t.string "delivery_id"
    t.string "delivery_name"
    t.datetime "delivery_at"
    t.string "return_id"
    t.string "return_name"
    t.datetime "return_at"
    t.string "drug_store_id"
    t.string "drug_store_name"
    t.datetime "effective_start"
    t.datetime "effective_end"
    t.string "diagnoses"
    t.string "specialmark"
    t.string "status"
    t.string "bill_id"
    t.datetime "bill_at"
    t.datetime "hospital_prescription_at"
    t.integer "hospital_prescription_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ims_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "org_ii", comment: "组织机构代码"
    t.string "org_name", collation: "utf8_german2_ci", comment: "组织机构名称"
    t.integer "returned_at", comment: "退药时间天数"
    t.integer "payment_expired", comment: "付费未取药过期天数"
    t.integer "unpaid_expired", comment: "未支付订单过期天数"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
    t.boolean "voice_prompts"
  end

  create_table "mtemplates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "org_id"
    t.string "status", default: ""
    t.string "title", default: ""
    t.string "note", default: ""
    t.string "sharing_scope_code", default: ""
    t.string "sharing_scope_display", default: ""
    t.string "disease_code", default: ""
    t.string "disease_display", default: ""
    t.string "author_id", default: ""
    t.string "author_display", default: ""
    t.string "location_id", default: ""
    t.string "location_display", default: ""
    t.string "search_str", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "source_org_ii"
    t.string "source_org_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders_order_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "item_id"
    t.string "name"
    t.string "order_id"
    t.float "quantity", limit: 24
    t.string "unit"
    t.string "specifications"
    t.string "dosage"
    t.float "price", limit: 24
    t.float "net_amt", limit: 24
    t.string "img_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firm", limit: 50
    t.bigint "ori_detail_id", comment: "退药情况下记录原单detail_id"
  end

  create_table "orders_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.time "payment_at"
    t.time "end_time"
    t.time "close_time"
    t.string "target_org_id"
    t.string "target_org_name"
    t.string "source_org_name"
    t.string "order_code"
    t.string "user_id"
    t.string "shipping_name"
    t.string "shipping_code"
    t.string "payment_type"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "doctor", limit: 32
    t.string "source_org_id", limit: 32
    t.string "person_id", limit: 32
    t.string "settle_id", limit: 32
    t.string "patient_name", limit: 50
    t.string "patient_phone", limit: 16
    t.string "drug_user", limit: 50
    t.string "drug_user_id", limit: 50
    t.string "patient_sex", limit: 10
    t.string "patient_age", limit: 10
    t.string "patient_iden", limit: 20
    t.string "pay_type", limit: 20
    t.boolean "is_returned", comment: "是否已退药"
    t.bigint "ori_id", comment: "原单id(退药的单子做记录)"
    t.string "ori_code", comment: "原单code(退药的单子做记录)"
    t.string "returner", comment: "退药人"
    t.bigint "returner_id", comment: "退药人id"
    t.datetime "return_at", comment: "退药时间"
    t.string "reason"
    t.integer "_locked"
    t.string "invoice_id"
    t.integer "settle_times"
  end

  create_table "pay_alipays", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "cost_name", default: ""
    t.string "out_trade_no", default: ""
    t.float "total_fee", limit: 24, default: 0.0
    t.string "title", default: ""
    t.string "return_url", default: ""
    t.string "status", default: ""
    t.string "status_desc", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pay_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "cost_name", default: ""
    t.string "out_trade_no", default: ""
    t.string "trade_type", default: ""
    t.string "pay_type", default: ""
    t.decimal "total_fee", precision: 15, scale: 2
    t.string "title", default: ""
    t.string "return_url", default: ""
    t.string "openid", default: ""
    t.string "status", default: ""
    t.string "status_desc", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pay_refunds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "order_id"
    t.string "reason", default: ""
    t.string "out_refund_no", default: ""
    t.decimal "refund_fee", precision: 15, scale: 2
    t.string "status", default: ""
    t.string "status_desc", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pay_wechats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "cost_name", default: ""
    t.string "out_trade_no", default: ""
    t.decimal "total_fee", precision: 11, default: "0"
    t.string "title", default: ""
    t.string "return_url", default: ""
    t.string "status", default: ""
    t.string "status_desc", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trade_type", limit: 200
  end

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "health_file_no"
    t.string "iden"
    t.string "health_card_no"
    t.string "name"
    t.datetime "birth_date"
    t.integer "age"
    t.string "gender_code"
    t.string "gender_display"
    t.string "nationality_code"
    t.string "nationality_display"
    t.string "home_town_province"
    t.string "home_town_city"
    t.string "nation_code"
    t.string "nation_display"
    t.string "marriage_code"
    t.string "marriage_display"
    t.string "education_code"
    t.string "education_display"
    t.string "occupation_code"
    t.string "occupation_display"
    t.string "phone"
    t.string "email"
    t.string "pa_post_code"
    t.string "pa_address"
    t.string "ha_post_code"
    t.string "ha_address"
    t.string "unit_name"
    t.string "unit_phone"
    t.string "ua_post_code"
    t.string "ua_address"
    t.string "contact_name"
    t.string "contact_relation_code"
    t.string "contact_relation_display"
    t.string "contact_phone"
    t.string "ca_post_code"
    t.string "ca_address"
    t.datetime "input_date"
    t.string "input_organ_code"
    t.string "input_organ_name"
    t.string "input_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.integer "person_id"
    t.string "blood_code"
    t.string "blood_display"
    t.float "height", limit: 24
    t.float "weight", limit: 24
  end

  create_table "position_datas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: ""
    t.string "title", default: ""
    t.float "lat", limit: 53
    t.float "lng", limit: 53
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relation_orders_and_prescriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "prescript_id"
    t.string "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settles_settles", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "order_code"
    t.float "net_amt", limit: 53
    t.string "pay_method", limit: 8
    t.string "pay_type", limit: 8
    t.string "out_trade_no", limit: 32
    t.string "body", limit: 128
    t.string "detail", limit: 6000
    t.string "device_info", limit: 32
    t.string "auth_code", limit: 128
    t.string "status", limit: 4
    t.string "order_id", limit: 50
  end

  create_table "sms_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "phone", default: ""
    t.string "name", default: ""
    t.string "code", default: ""
    t.string "expired_in", default: ""
    t.string "data_type", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone"], name: "index_sms_messages_on_phone"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "jianpin"
    t.string "type_code"
    t.string "organization_id"
    t.string "sex"
    t.string "birth"
    t.string "pharmacy_id"
    t.string "openid"
    t.string "headimgurl"
    t.integer "cur_loc_id", comment: "当前用户科室id"
    t.string "cur_loc_display", limit: 100, comment: "当前科室名称"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

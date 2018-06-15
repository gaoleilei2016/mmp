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
ActiveRecord::Schema.define(version: 20180612072906) do
<<<<<<< HEAD
=======

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
  end

  create_table "admin_organizations_organizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "organization_id"
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

  create_table "dictarea", primary_key: "serialno", id: :integer, comment: "序号", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "supcode", limit: 30, comment: "上级"
    t.string "code", limit: 30, null: false, comment: "编码"
    t.string "name", limit: 100, null: false, comment: "名称"
    t.string "py", limit: 50, comment: "拼音码"
    t.string "wb", limit: 50, comment: "五笔码"
    t.string "status", limit: 1, default: "A", comment: "状态(N: '新建'   A: '活动'   T: '停用')"
    t.index ["name", "py", "wb"], name: "idx_area_name"
  end

  create_table "dictdata", primary_key: "serialno", id: :integer, comment: "序号", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  create_table "dictdatagroup", primary_key: "serialno", id: :integer, comment: "序号", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "oid", limit: 30, comment: "字典识别码"
    t.string "name", limit: 100, null: false, comment: "名称"
    t.text "remark", comment: "备注"
    t.index ["oid"], name: "idx_dictgp_oid", unique: true
  end

  create_table "dictdisease", primary_key: "serialno", id: :integer, comment: "序号", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "疾病字典表" do |t|
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

  create_table "dictmedicine", primary_key: "serialno", id: :integer, comment: "序号", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "药品字典表" do |t|
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
    t.decimal "measure_val", precision: 10, comment: "最小计量值"
    t.string "purch_unit", limit: 30, comment: "采购单位"
    t.string "unit", limit: 30, comment: "销售单位"
    t.decimal "mul", precision: 10, comment: "倍率"
    t.decimal "purch_price", precision: 10, comment: "采购价格"
    t.decimal "price", precision: 10, comment: "销售价格"
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
    t.string "code"
    t.string "display"
    t.string "system"
    t.string "status"
    t.string "rank"
    t.string "encounter_id"
    t.string "doctor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prescription_id"
  end

  create_table "hospital_encounters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "iden"
    t.string "name"
    t.string "name_jp"
    t.string "name_wb"
    t.datetime "birth_date"
    t.integer "age", unsigned: true
    t.string "gender_code"
    t.string "gender_display"
    t.string "occupation_code"
    t.string "occupation_display"
    t.string "phone"
    t.string "address"
    t.string "unit_name"
    t.string "ua_address"
    t.string "unit_phone"
    t.string "contact_name"
    t.string "contact_phone"
    t.string "hospital_oid"
    t.string "hospital_name"
    t.string "patient_domain_code"
    t.string "patient_domain_display"
    t.string "outpatient_no"
    t.string "inpatient_no"
    t.string "started_at"
    t.string "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nation_code"
    t.string "nation_display"
    t.string "blood_code"
    t.string "blood_display"
    t.integer "drugstore_location_id"
    t.string "marriage_code"
    t.string "marriage_display"
    t.string "height"
    t.string "weight"
    t.integer "person_id"
  end

  create_table "hospital_irritabilities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "code"
    t.string "display"
    t.string "system"
    t.string "status"
    t.string "period_start"
    t.string "datetime"
    t.string "data_entry_id"
    t.string "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hospital_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.string "status"
    t.integer "order_type", default: 1
    t.integer "encounter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prescription_id"
  end

  create_table "hospital_prescriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "organization_id"
    t.string "status"
    t.string "note"
    t.string "type_code"
    t.integer "bill_id"
    t.string "confidentiality_code"
    t.integer "doctor_id"
    t.integer "encounter_id"
    t.datetime "effective_start"
    t.datetime "effective_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type_display", comment: "处分类型名称"
    t.string "confidentiality_display", comment: " 权限描述"
    t.string "prescription_no", comment: "处方号"
    t.boolean "specialmark", default: false, comment: "特殊处方标记"
  end

  create_table "hospital_sets_inis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean "enable_print_pres", default: false, comment: "是否启用打印"
    t.integer "uoperator_id"
    t.text "print_pres_html"
    t.integer "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ims_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "source_org_ii", comment: "来源机构"
    t.string "source_org_name", comment: "来源机构名称"
    t.string "target_org_ii", comment: "目标机构代码"
    t.string "target_org_name", comment: "目标机构名称"
    t.string "patient_order_id", comment: "患者订单id"
    t.string "order_code", comment: "订单号"
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

  create_table "ims_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "org_ii", comment: "组织机构代码"
    t.string "org_name", collation: "utf8_german2_ci", comment: "组织机构名称"
    t.integer "returned_at", comment: "退药时间天数"
    t.integer "payment_Expired", comment: "付费未取药过期天数"
    t.integer "unpaid_expired", comment: "未支付订单过期天数"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
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
  end
  create_table "orders_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.time "payment_at"
    t.time "end_time"
    t.time "close_time"
    t.string "target_org_id"
    t.string "target_org_name"
    t.string "source_org_id"
    t.string "source_org_name"
    t.string "phone_number"
    t.string "order_code"
    t.string "user_id"
    t.string "person_id"
    t.string "doctor"
    t.string "shipping_name"
    t.string "shipping_code"
    t.float "payment_type", limit: 24
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

>>>>>>> qinxiao
end

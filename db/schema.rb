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

ActiveRecord::Schema.define(version: 20180920082245) do

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
    t.string "addr"
    t.float "lat", limit: 53
    t.float "lng", limit: 53
    t.boolean "yaofang_type"
    t.integer "search_count"
    t.binary "picture"
  end

  create_table "customer_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "user_id"
    t.string "ii"
    t.boolean "flag"
    t.string "info"
  end

  create_table "customer_feedbacks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "user_id"
    t.string "content"
    t.string "contact"
    t.string "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reply"
  end

  create_table "customer_invoice_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "default"
    t.string "user_id"
    t.string "name"
    t.string "shuihao"
    t.string "addr"
    t.string "telephone"
    t.string "bank"
    t.string "bank_num"
    t.string "type_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type_class"
    t.string "content"
  end

  create_table "customer_pharmacy_histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "pharmacy_id"
    t.string "user_id"
    t.integer "use_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "use_type"
    t.float "lat", limit: 53
    t.float "lng", limit: 53
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

  create_table "health_blood_pressures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "code", default: ""
    t.integer "systolic_value"
    t.integer "diastolic_value"
    t.string "state", default: ""
    t.string "state_desc", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "health_cloud_ws_blood_sugars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "intServerID"
    t.string "datRecordTime"
    t.integer "intConsistency"
    t.string "intTypeID"
    t.string "strMemo"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_bloods", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "intServerID"
    t.string "datRecordTime"
    t.integer "intSystolic"
    t.integer "intDiastolic"
    t.integer "intPulse"
    t.integer "intTypeID"
    t.string "strMeno"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_diets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "intServerID"
    t.string "datRecordTime"
    t.string "intDietType"
    t.string "img1"
    t.string "img2"
    t.string "img3"
    t.string "img4"
    t.string "img5"
    t.string "img6"
    t.string "img7"
    t.string "img8"
    t.string "img9"
    t.string "strMemo"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_ecg_breaths", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "intServerID"
    t.string "datRecordTime"
    t.integer "intRecordLevel"
    t.integer "intTrainingTime"
    t.integer "intAvgHR"
    t.integer "intMaxHR"
    t.integer "intMinHR"
    t.string "strMemo"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_ecg_hearts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "intServerID"
    t.string "datRecordTime"
    t.integer "intHeartbeat"
    t.integer "intPressure"
    t.integer "intVitalityAge"
    t.integer "intEmoIndex"
    t.string "strMemo"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_heart_vts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "HRIndex"
    t.string "HRValue"
    t.string "intServerID"
    t.string "strMemo"
    t.string "userid"
    t.string "strPrgID"
    t.string "strRecordDate"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_hearts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "intServerID"
    t.string "datRecordTime"
    t.string "strHR"
    t.string "strMemo"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "method"
    t.string "info"
    t.string "time"
    t.string "error"
  end

  create_table "health_cloud_ws_members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "intServerID"
    t.boolean "bolisMale"
    t.float "floHeight", limit: 24
    t.string "datStartdate"
    t.string "datEnddate"
    t.float "floFtweight", limit: 24
    t.float "floTgweight", limit: 24
    t.float "floFtBodyFat", limit: 24
    t.float "floTgBodyFat", limit: 24
    t.float "floFtWaistline", limit: 24
    t.float "floTgWaistline", limit: 24
    t.float "floFtButtocks", limit: 24
    t.float "floTgButtocks", limit: 24
    t.integer "intSportCount"
    t.integer "intSportOneMin"
    t.string "datBreakfristST"
    t.string "datBreakfristET"
    t.string "datLunchST"
    t.string "datLunchET"
    t.string "datDinnerST"
    t.string "datDinnerET"
    t.string "datForbiddenST1"
    t.string "datForbiddenET1"
    t.string "datForbiddenST2"
    t.string "datForbiddenET2"
    t.integer "intActivity"
    t.integer "intRreducingCalorie"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_questions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "intQuestionID"
    t.string "strContent"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_rings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "intSportType"
    t.string "strAutoMeasure"
    t.string "strMemo"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
    t.string "serverId"
    t.string "recordTime"
    t.string "footSteps"
    t.string "sportMinutes"
    t.string "distance"
    t.string "calorie"
  end

  create_table "health_cloud_ws_sleep_vts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "datStartTime"
    t.string "datEndTime"
    t.integer "intDeepMinutes"
    t.integer "intLightMinutes"
    t.integer "intAwakeMinutes"
    t.string "sleepTime"
    t.string "sleepLevel"
    t.integer "intServerID"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_sleeps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "datStartTime"
    t.string "datEndTime"
    t.integer "intDeepMinutes"
    t.integer "intLightMinutes"
    t.string "strSleepRawData"
    t.integer "intServerID"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_sports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "intServerID"
    t.string "datRecordTime"
    t.string "intSportType"
    t.integer "intSportMinutes"
    t.float "dubDistance", limit: 24
    t.integer "intFootSteps"
    t.integer "intCalorie"
    t.string "strAutoMeasure"
    t.string "strMemo"
    t.string "img1"
    t.string "img2"
    t.string "img3"
    t.string "img4"
    t.string "img5"
    t.string "img6"
    t.string "img7"
    t.string "img8"
    t.string "img9"
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_cloud_ws_sys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "strPrgID"
    t.string "strPrgPws"
    t.string "company"
  end

  create_table "health_cloud_ws_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "strUserAccount"
    t.string "strDisplayName"
    t.string "bolisMale"
    t.boolean "bolisAgreement"
    t.string "strCell"
    t.string "strEMail"
    t.string "strPassword"
    t.string "UserPhoto"
    t.string "strBirthday"
    t.string "strAddSecCode"
    t.string "strCommunityCode"
    t.integer "intUserID"
  end

  create_table "health_cloud_ws_weights", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "intServerID"
    t.string "datRecordTime"
    t.float "floWeight", limit: 24
    t.float "floBodyFat", limit: 24
    t.float "floWaistline", limit: 24
    t.float "floButtocks", limit: 24
    t.float "floRateOfBone", limit: 24
    t.float "floSoftLeanMass", limit: 24
    t.float "floTotalBodyWater", limit: 24
    t.float "floBMR", limit: 24
    t.float "floVisceralFat", limit: 24
    t.float "floPhysicalAge", limit: 24
    t.string "userid"
    t.string "strPrgID"
    t.string "strUserAccount"
  end

  create_table "health_qrcodes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "code", default: ""
    t.binary "img_data"
    t.string "text", default: ""
    t.string "img_type", default: ""
    t.string "status", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "health_weights", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "sex", default: ""
    t.integer "age"
    t.string "bmi", default: ""
    t.string "height", default: ""
    t.string "code", default: ""
    t.string "data", default: ""
    t.string "max_heart_rate", default: ""
    t.string "normal_heart_rate", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "health_wowgos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "api_code", default: ""
    t.string "user_name", default: ""
    t.string "gender", default: ""
    t.string "height", default: ""
    t.string "birth", default: ""
    t.string "headimgurl", default: ""
    t.string "qrcode_text", default: ""
    t.string "userid", default: ""
    t.string "return_code", default: ""
    t.string "return_msg", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "type_code", comment: "诊断类型 0 主要诊断  1 次要诊断"
    t.string "type_display", limit: 10, comment: "诊断类型名称"
    t.bigint "org_id", comment: "机构id"
  end

  create_table "hospital_dict_codings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "code", limit: 20, comment: "编码"
    t.string "display", limit: 60, comment: "编码名称"
    t.string "system", limit: 60, comment: "编码系统识别号"
    t.string "jianpin", limit: 60, comment: "简拼"
    t.string "wubi", limit: 60, comment: "五笔"
    t.string "status", limit: 2, default: "A", comment: "状态"
    t.bigint "org_id", null: false, comment: "机构id"
    t.string "version", limit: 20, comment: "版本号"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.text "photo", comment: "照片"
    t.bigint "encounter_loc_id", comment: "就诊科室id"
    t.string "encounter_loc_display", limit: 60, comment: "就诊科室名称"
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

  create_table "hospital_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "serialno", null: false, comment: "药品序号id"
    t.string "title", limit: 120, null: false, comment: "医嘱名称"
    t.string "specification", limit: 20, comment: "药品规格"
    t.float "single_qty_value", limit: 24, null: false, comment: "单次数量的值"
    t.string "single_qty_unit", limit: 30, comment: "单次数量的单位"
    t.float "dose_value", limit: 24, null: false, comment: "单次剂量的值"
    t.string "dose_unit", comment: "单次剂量的单位( 有些药品没有基本剂量的单位)"
    t.string "route_code", limit: 10, null: false, comment: "途径编码"
    t.string "route_display", limit: 30, null: false, comment: "途径编码名称"
    t.string "frequency_code", limit: 10, null: false, comment: "频次编码"
    t.string "frequency_display", limit: 30, null: false, comment: "频次编码名称"
    t.integer "course_of_treatment_value", comment: "疗程的值"
    t.string "course_of_treatment_unit", limit: 10, default: "天", comment: "疗程的单位（天）"
    t.float "total_quantity", limit: 24, null: false, comment: "总量值"
    t.string "unit", limit: 10, null: false, comment: "总量单位"
    t.float "price", limit: 24, null: false, comment: "单价"
    t.string "note", comment: "备注"
    t.integer "status", default: 0, comment: "医嘱状态"
    t.integer "order_type", default: 1, null: false, comment: "医嘱类型  1是药品医嘱  以后有其他的类型往后加"
    t.bigint "encounter_id", comment: "就诊id  Hospital::Encounter"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
    t.bigint "prescription_id", comment: "处方id Hospital::Prescription"
    t.bigint "author_id", comment: "作者id User"
    t.string "formul_code", limit: 8, comment: "剂型编码"
    t.string "formul_display", limit: 20, comment: "剂型名称"
    t.bigint "mtemplate_id", comment: "模板id Hospital::Sets::Mtemplate"
    t.string "factory_name", limit: 60, comment: "厂家名称"
    t.string "base_unit", limit: 30, comment: "基本单位"
    t.decimal "mul", precision: 10, null: false, comment: "销售/基本单位的倍率"
    t.decimal "measure_val", precision: 10, null: false, comment: " 最小计量值"
    t.string "measure_unit", limit: 30, default: "", comment: "最小计量单位"
    t.string "type_type", limit: 10, default: "instance", null: false, comment: "医嘱类型  instance 实例医嘱  template 模板医嘱"
    t.integer "rank_in_prescription", limit: 3, comment: "医嘱在处方中的顺序"
  end

  create_table "hospital_prescriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "organization_id", null: false, comment: "处方所属机构id Admin::Organization"
    t.integer "status", limit: 1, default: 1, null: false, comment: "处方状态:0 未审核,  1:已审核   2:待收费   3:已收费   4:已发药   7:已废弃  8:已退药  9:已退费"
    t.string "note", comment: "处方备注"
    t.string "type_code", limit: 10, null: false, comment: "处方类型编码"
    t.bigint "bill_id", comment: "账单id"
    t.string "confidentiality_code", limit: 8, null: false, comment: "权限编码"
    t.bigint "doctor_id", null: false, comment: "医生id"
    t.bigint "encounter_id", null: false, comment: "就诊id"
    t.datetime "effective_start", null: false, comment: "处方有效时间开始"
    t.datetime "effective_end", null: false, comment: "处方有效时间结束"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
    t.string "type_display", limit: 40, null: false, comment: "处方类型名称"
    t.string "confidentiality_display", limit: 20, null: false, comment: " 权限描述"
    t.integer "prescription_no", comment: "处方号"
    t.boolean "specialmark", default: false, comment: "特殊处方标记"
    t.bigint "drug_store_id", comment: "药房id"
    t.bigint "order_id", comment: "账单id"
    t.string "tookcode", limit: 10, comment: "取药码"
    t.bigint "author_id", comment: "作者id User"
    t.bigint "auditor_id", comment: "审核人id User"
    t.string "auditor_display", limit: 60, comment: "审核人姓名"
    t.datetime "audit_at", comment: "审核时间"
    t.bigint "abandonor_id", comment: "废弃人 User"
    t.string "abandonor_display", limit: 60, comment: "废弃人姓名"
    t.datetime "abandon_at", comment: "废弃时间"
    t.bigint "delivery_id", comment: "发药人User"
    t.string "delivery_display", limit: 60, comment: "发药人姓名"
    t.datetime "delivery_at", comment: "发药时间"
    t.bigint "create_bill_opt_id", comment: "账单创建人 User"
    t.string "create_bill_opt_display", limit: 60, comment: "账单创建姓名"
    t.datetime "bill_at", comment: "账单创建时间"
    t.bigint "charger_id", comment: "收费人 User"
    t.string "charger_display", limit: 60, comment: "收费人姓名"
    t.datetime "charge_at", comment: "收费时间"
    t.bigint "return_charge_opt_id", comment: "退费人 User"
    t.string "return_charge_opt_display", limit: 60, comment: "退费人名称"
    t.datetime "return_charge_at", comment: "退费时间"
    t.boolean "is_read", default: false, comment: "用户处方是否已读"
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
    t.integer "encounter_search_time", limit: 2, comment: "就诊查询字段"
    t.bigint "prescription_audit_id", comment: "处分审核人 User"
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

  create_table "ims_inv_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "org_id"
    t.integer "medicine_id"
    t.string "name"
    t.string "spec"
    t.string "formul_name"
    t.string "entry_type"
    t.string "pt_code"
    t.string "code"
    t.string "unit"
    t.float "price", limit: 24
    t.string "mul"
    t.string "batch"
    t.string "location_id"
    t.string "location_name"
    t.float "quantity", limit: 24
    t.float "amount", limit: 24
    t.string "source_id"
    t.string "source_name"
    t.string "document_id"
    t.string "document_code"
    t.string "document_line_id"
    t.string "note"
    t.string "operater"
    t.string "operater_id"
    t.datetime "operat_at"
    t.string "patient_name"
    t.datetime "posting_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ims_inv_select_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "use_org_id"
    t.integer "c_id"
    t.string "use_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ims_inv_stocks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "org_id"
    t.integer "medicine_id"
    t.string "pt_code"
    t.string "code"
    t.string "unit"
    t.float "price", limit: 24
    t.string "mul"
    t.string "batch"
    t.string "location_id"
    t.string "location_name"
    t.float "quantity", limit: 24
    t.float "freeze_qty", limit: 24
    t.float "amount", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ims_per_sum_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "header_id"
    t.string "drug_id"
    t.string "title"
    t.string "specification"
    t.float "unit", limit: 24
    t.string "price"
    t.float "amount", limit: 24
    t.string "author_id"
    t.string "factory_name"
    t.string "ori_detail_id"
    t.string "prescription_no"
    t.string "name"
    t.string "iden"
    t.string "source_org_id"
    t.string "source_org_name"
    t.string "delivery_id"
    t.string "delivery_nameme"
    t.string "delivery_org_id"
    t.string "delivery_org_name"
    t.string "charger_id"
    t.string "charger_name"
    t.string "charge_at"
    t.string "return_charge_opt_id"
    t.string "return_charge_opt_name"
    t.datetime "created_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.datetime "return_charge_at"
  end

  create_table "ims_per_sum_of_days", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "source_org_id"
    t.string "drug_name"
    t.datetime "drug_delivery_time"
    t.string "specification"
    t.float "number", limit: 24
    t.string "company"
    t.float "price", limit: 24
    t.float "net_amt", limit: 24
    t.string "manufacturer"
    t.date "created_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "delivery_id"
    t.string "status"
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
    t.float "price", limit: 24
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
    t.integer "header_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ims_pre_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "prescription_no", limit: 20
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
    t.boolean "is_returned", comment: "原单是否是已退药"
    t.integer "ori_id", comment: "原单id（退药）"
    t.string "ori_code", comment: "原单code（退药）"
    t.string "tookcode"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ims_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "org_ii", default: "", comment: "组织机构"
    t.string "org_name", default: "", comment: "组织机构名称"
    t.string "returned_at", default: "", comment: "可退药时间天数"
    t.string "payment_Expired", default: "", comment: "付费未取药过期天数"
    t.string "unpaid_expired", default: "", comment: "未支付订单过期天数"
    t.boolean "voice_prompts", comment: "是否语音提示"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders_order_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "item_id", default: "", comment: "商品id"
    t.string "name", default: "", comment: "商品名字"
    t.string "order_id", default: "", comment: "订单id"
    t.float "quantity", limit: 24, default: 0.0, comment: "数量"
    t.string "unit", default: "", comment: "单位"
    t.string "specifications", default: "", comment: "规格"
    t.string "dosage", default: "", comment: "剂型"
    t.float "price", limit: 24, default: 0.0, comment: "单价"
    t.float "net_amt", limit: 24, default: 0.0, comment: "总价"
    t.string "persecipt_id", default: "", comment: "处方id"
    t.string "img_path", default: "", comment: "图片"
    t.string "firm", default: "", comment: "厂家"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prescription_id", default: "", comment: "处方id"
    t.time "refund_medical_time", comment: "退药时间"
    t.string "refund_medical_reason", default: "", comment: "退药原因"
  end

  create_table "orders_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.time "payment_at", comment: "支付时间"
    t.time "end_time", comment: "订单完成时间"
    t.time "close_time", comment: "订单关闭时间"
    t.string "target_org_id", default: "", comment: "药店id"
    t.string "target_org_name", default: "", comment: "药店name"
    t.string "source_org_id", default: "", comment: "医院id"
    t.string "source_org_name", default: "", comment: "医院name"
    t.string "order_code", default: "", comment: "订单号"
    t.string "user_id", default: "", comment: "用户id"
    t.string "person_id", default: "", comment: "患者id"
    t.string "doctor", default: "", comment: "开单医生"
    t.string "shipping_name", default: "", comment: "物流名称"
    t.string "shipping_code", default: "", comment: "物流单号"
    t.integer "payment_type", default: 0, comment: "支付类别,1.在线支付,2.线下支付"
    t.string "status", default: "", comment: "订单状态：1待付款,2待领药,3未发货,4已发货,5交易完成,6已退药,7交易关闭"
    t.string "patient_name", default: "", comment: "患者名字"
    t.string "patient_phone", default: "", comment: "患者手机"
    t.string "drug_user", default: "", comment: "发药人"
    t.string "drug_user_id", default: "", comment: "发药人id"
    t.string "patient_sex", default: "", comment: "患者性别"
    t.string "patient_age", default: "", comment: "年龄"
    t.string "patient_iden", default: "", comment: "身份证"
    t.string "pay_type", default: "", comment: "支付类型,Alipay ,Wechat"
    t.string "reason", default: "", comment: "退费退药原因"
    t.integer "_locked", default: 0, comment: "锁标记"
    t.string "invoice_id", default: "", comment: "发票id"
    t.integer "settle_times", default: 0, comment: "结算次数"
    t.integer "is_send_medical", default: 0, comment: "是否发药"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lock_version", comment: "乐观锁的锁版本号"
    t.datetime "order_failure_time", comment: "订单失效时间"
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

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "health_file_no", comment: "居民健康档案号"
    t.string "iden", comment: "份证件号码"
    t.string "health_card_no", comment: "居民健康卡号"
    t.string "name", comment: "姓名"
    t.datetime "birth_date", comment: "出生日期"
    t.integer "age", comment: "年龄"
    t.string "gender_code", comment: "性别代码"
    t.string "gender_display", comment: "性别名称"
    t.string "nationality_code", comment: "国籍代码"
    t.string "nationality_display", comment: "国籍名称"
    t.string "home_town_province", comment: "籍贯-省（自治区、直辖市）"
    t.string "home_town_city", comment: "籍贯-市（地区、州）"
    t.string "nation_code", comment: "民族代码"
    t.string "nation_display", comment: "民族名称"
    t.string "marriage_code", comment: "婚姻状况代码"
    t.string "marriage_display", comment: "婚姻状况名称"
    t.string "education_code", comment: "文化程度代码"
    t.string "education_display", comment: "文化程度"
    t.string "occupation_code", comment: "职业编码"
    t.string "occupation_display", comment: "职业编码名称"
    t.string "phone", comment: "联系电话"
    t.string "email", comment: "邮箱"
    t.string "pa_post_code", comment: "现居地址邮政编码"
    t.string "pa_address", comment: "现居地址"
    t.string "ha_post_code", comment: "户口地址邮政编码"
    t.string "ha_address", comment: "户口地址"
    t.string "unit_name", comment: "工作单位名称"
    t.string "unit_phone", comment: "工作单位联系电话"
    t.string "ua_post_code", comment: "工作单位地址邮政编码"
    t.string "ua_address", comment: "工作单位详细地址"
    t.string "contact_name", comment: "联系人姓名"
    t.string "contact_relation_code", comment: "联系人与本人关系代码"
    t.string "contact_relation_display", comment: "联系人与本人关系编码名称"
    t.string "contact_phone", comment: "联系人电话"
    t.string "ca_post_code", comment: "联系人地址邮政编码"
    t.string "ca_address", comment: "联系人详细地址"
    t.datetime "input_date", comment: "建档时间"
    t.string "input_organ_code", comment: "建档人机构组织机构代码或者信用代码"
    t.string "input_organ_name", comment: "建档人机构名称"
    t.string "input_name", comment: "建档人姓名"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.datetime "updated_at", null: false, comment: "更新时间"
    t.string "blood_code", comment: "血型编码"
    t.string "blood_display", comment: "血型编码名称"
    t.float "height", limit: 24, comment: "身高  单位cm"
    t.float "weight", limit: 24, comment: " 体重 单位kg"
    t.string "name_jp", limit: 60
    t.string "name_wb", limit: 60
    t.text "photo", comment: "照片"
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
    t.string "name"
    t.string "jianpin"
    t.string "type_code"
    t.string "organization_id"
    t.string "sex"
    t.string "birth"
    t.string "headimgurl"
    t.string "admin_level"
    t.string "openid"
    t.string "openname"
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
    t.string "cur_loc_display"
    t.string "cur_loc_id"
    t.string "height"
    t.boolean "wowgo"
    t.string "expired_in"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

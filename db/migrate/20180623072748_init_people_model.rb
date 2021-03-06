class InitPeopleModel < ActiveRecord::Migration[5.1]
  def change
      create_table :people, force: :cascade do |t|
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
        t.string "photo", comment: "照片"
        t.string "blood_code", comment: "血型编码"
        t.string "blood_display", comment: "血型编码名称"
        t.float "height", limit: 24, comment: "身高  单位cm"
        t.float "weight", limit: 24, comment: " 体重 单位kg"
        t.string "name_jp", limit: 60
        t.string "name_wb", limit: 60
      end
  end
end



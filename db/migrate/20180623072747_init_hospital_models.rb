class InitHospitalModels < ActiveRecord::Migration[5.1]
  def change
  	create_table :hospital_sets_departments do |t|
	  	t.bigint "org_id", null: false, comment: "机构id"
	    t.string "name", limit: 20, default: "", null: false, comment: "科室名称"
	    t.string "jianpin", limit: 20, default: "", comment: "科室简称"
	    t.string "status", limit: 2, default: "", null: false, comment: "状态 N 新建   A 活动  O作废"
	    t.string "search_str", default: "", comment: "模糊查询字段"
	    t.datetime "created_at", null: false, comment: "创建时间"
	    t.datetime "updated_at", null: false, comment: "更新时间"
	    t.string "note", comment: "科室备注"
		end
  end

  def change
    create_table :hospital_sets_inis, force: :cascade do |t|
	    t.boolean "enable_print_pres", default: false, comment: "是否启用处方打印 1是true  0是false"
	    t.integer "uoperator_id", null: false, comment: "最后更新人 User.id"
	    t.text "print_pres_html", comment: "打印模板  写了触发器"
	    t.integer "org_id", null: false, comment: "机构id"
	    t.datetime "created_at", null: false, comment: "创建时间"
	    t.datetime "updated_at", null: false, comment: "更新时间"
	    t.int "encounter_search_time", limit: 2, comment: "就诊查询字段"
	    t.bigint "prescription_audit_id", limit: 20, comment: "处分审核人 User"
		end
  end

  def change
  	create_table "hospital_sets_mtemplates", force: :cascade do |t|
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
  end
end

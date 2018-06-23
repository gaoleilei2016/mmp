class CreateHospitalDictCodings < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_dict_codings do |t|
      t.string :code, limit: 20, comment: "编码"
      t.string :display, limit: 60, comment: "编码名称"
      t.string :system, limit: 60, comment: "编码系统识别号"
      t.string :jianpin, limit: 60, comment: "简拼"
      t.string :wubi, limit: 60, comment: "五笔"
      t.string :status, limit: 2, default: "A", comment: "状态"
      t.bigint :org_id, limit: 20, null:false, comment: "机构id"
      t.string :version, limit: 20, comment: "版本号" 
      t.timestamps
    end
  end
end

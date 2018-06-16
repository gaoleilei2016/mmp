class CreateHospitalSetsLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_sets_locations do |t|
      t.integer :org_id, comment: "机构id"
      t.string :name, comment: "科室名称"
      t.string :jianpin, comment: "科室简称"
      t.string :status, comment: "状态"

      t.timestamps
    end
  end
end

class CreateHospitalSetsInis < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_sets_inis do |t|
      t.boolean :enable_print_pres, default: false, comment: "是否启用打印"
      t.integer :uoperator_id
      t.text :print_pres_html
      t.integer :org_id

      t.timestamps
    end
  end
end
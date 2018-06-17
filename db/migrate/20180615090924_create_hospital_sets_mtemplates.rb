class CreateHospitalSetsMtemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_sets_mtemplates do |t|
      t.integer :org_id
      t.string :status
      t.string :title
      t.string :note
      t.string :sharing_scope_code
      t.string :sharing_scope_display
      t.string :disease_code
      t.string :disease_display
      t.integer :author_id
      t.string :author_display
      t.integer :location_id
      t.string :location_display
      t.string :search_str

      t.timestamps
    end
  end
end

class CreateImsInvEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_inv_entries do |t|
      t.integer :org_id
      t.integer :medicine_id
      t.string :name
      t.string :spec
      t.string :formul_name
      t.string :entry_type
      t.string :pt_code
      t.string :code
      t.string :unit
      t.float :price
      t.string :mul
      t.string :batch
      t.string :location_id
      t.string :location_name
      t.float :quantity
      t.float :amount
      t.string :source_id
      t.string :source_name
      t.string :document_id
      t.string :document_code
      t.string :document_line_id
      t.string :note
      t.string :operater
      t.string :operater_id
      t.datetime :operat_at
      t.string :patient_name
      t.datetime :posting_on
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end

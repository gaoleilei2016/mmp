class CreateImsPrescriptionHeaders < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_prescription_headers do |t|
      t.string :prescription_no
      t.string :note
      t.string :type_code
      t.string :type_name
      t.string :confidentiality_code
      t.string :confidentiality_name
      t.string :name
      t.string :gender_code
      t.string :gender_name
      t.string :age
      t.datetime :birth_date
      t.string :iden
      t.string :occupation_code
      t.string :occupation_name
      t.string :phone
      t.string :address
      t.string :org_id
      t.string :org_display
      t.string :patient_no
      t.string :author_id
      t.string :author_display
      t.string :encounter_loc_id
      t.string :encounter_loc_display
      t.float :total_amount
      t.string :orders
      t.string :delivery_id
      t.string :delivery_name
      t.datetime :delivery_at
      t.string :return_id
      t.string :return_name
      t.datetime :return_at
      t.string :drug_store_id
      t.string :drug_store_name
      t.datetime :effective_start
      t.datetime :effective_end
      t.string :diagnoses
      t.string :specialmark
      t.string :status
      t.string :bill_id
      t.datetime :bill_at
      t.datetime :hospital_prescription_at
      t.integer :hospital_prescription_id

      t.timestamps
    end
  end
end
class CreateImsPreHeaders < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_pre_headers do |t|
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
      t.integer :source_org_id
      t.string :source_org_name
      t.string :patient_no
      t.integer :author_id
      t.string :author_name
      t.integer :auditor_id
      t.string :auditor_name
      t.datetime :audit_at
      t.integer :charger_id
      t.string :charger_name
      t.datetime :charge_at
      t.integer :encounter_loc_id
      t.string :encounter_loc_name
      t.float :total_amount
      t.integer :delivery_id
      t.string :delivery_name
      t.integer :delivery_org_id
      t.string :delivery_org_name
      t.datetime :delivery_at
      t.integer :return_id
      t.string :return_name
      t.integer :return_org_id
      t.string :return_org_name
      t.datetime :return_at
      t.integer :drug_store_id
      t.string :drug_store_name
      t.datetime :effective_start
      t.datetime :effective_end
      t.string :diagnoses
      t.string :specialmark
      t.string :status
      t.integer :order_id
      t.string :order_code
      t.datetime :order_at
      t.integer :create_bill_opt_id
      t.string :create_bill_opt_name
      t.datetime :hospital_prescription_at
      t.integer :hospital_prescription_id
      t.boolean :is_returned
      t.integer :ori_id
      t.string :ori_code
      t.string :tookcode
      t.string :reason

      t.timestamps
    end
  end
end

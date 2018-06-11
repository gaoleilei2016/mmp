class CreateHospitalEncounters < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_encounters do |t|
      t.string :iden
      t.string :name
      t.string :name_jp
      t.string :name_wb
      t.datetime :birth_date
      t.integer :age
      t.string :gender_code
      t.string :gender_display
      t.string :occupation_code
      t.string :occupation_display
      t.string :phone
      t.string :address
      t.string :unit_name
      t.string :ua_address
      t.string :unit_phone
      t.string :contact_name
      t.string :contact_phone
      t.string :hospital_oid
      t.string :hospital_name
      t.string :patient_domain_code
      t.string :patient_domain_display
      t.string :outpatient_no
      t.string :inpatient_no
      t.string :started_at
      t.string :datetime

      t.timestamps
    end
  end
end

class CreateHospitalEncounters < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_encounters do |t|
      t.string :iden
      t.string :string
      t.string :name
      t.string :string
      t.string :name_jp
      t.string :name_wb
      t.datetime :birth_date
      t.string :age
      t.string :integer
      t.string :gender_code
      t.string :string
      t.string :gender_display
      t.string :string
      t.string :occupation_code
      t.string :string
      t.string :occupation_display
      t.string :string
      t.string :phone
      t.string :string
      t.string :address
      t.string :string
      t.string :unit_name
      t.string :string
      t.string :ua_address
      t.string :string
      t.string :unit_phone
      t.string :string
      t.string :contact_name
      t.string :string
      t.string :contact_phone
      t.string :string
      t.string :hospital_oid
      t.string :string
      t.string :hospital_name
      t.string :string
      t.string :patient_domain_code
      t.string :string
      t.string :patient_domain_display
      t.string :string
      t.string :outpatient_no
      t.string :string
      t.string :inpatient_no
      t.string :string
      t.string :started_at
      t.string :datetime

      t.timestamps
    end
  end
end

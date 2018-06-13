class CreateHospitalPrescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_prescriptions do |t|
      t.integer :organization_id
      t.string :status
      t.string :note
      t.string :code
      t.integer :bill_id
      t.string :confidentiality
      t.integer :doctor_id
      t.integer :encounter_id
      t.datetime :effective_start
      t.datetime :effective_end

      t.timestamps
    end
  end
end

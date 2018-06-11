class CreateHospitalDiagnoses < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_diagnoses do |t|
      t.string :code
      t.string :display
      t.string :system
      t.string :status
      t.string :rank
      t.string :encounter_id
      t.string :doctor_id
      
      t.timestamps
    end
  end
end

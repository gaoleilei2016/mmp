class CreateHospitalDiagnoses < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_diagnoses do |t|
      t.string :code
      t.string :string
      t.string :display
      t.string :string
      t.string :system
      t.string :string
      t.string :status
      t.string :code
      t.string :rank
      t.string :integer
      t.string :encounter_id
      t.string :integer
      t.string :doctor_id
      t.string :integer

      t.timestamps
    end
  end
end

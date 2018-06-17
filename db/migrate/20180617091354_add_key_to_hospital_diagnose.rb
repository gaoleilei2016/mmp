class AddKeyToHospitalDiagnose < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_diagnoses, :type, :integer
    add_column :hospital_diagnoses, :note, :string
    add_column :hospital_diagnoses, :fall_ill_at, :datetime
  end
end

class AddKeyToHospitalDiagnoses < ActiveRecord::Migration[5.1]
  def change
  	add_column :hospital_diagnoses, :prescription_id, :integer
  end
end

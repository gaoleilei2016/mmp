class AddKey2ToHospitalDiagnose < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_diagnoses, :type_code, :integer
    add_column :hospital_diagnoses, :type_display, :string
  end
end

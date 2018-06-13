class AddKey2ToHospitalEncounter < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_encounters, :height, :string
    add_column :hospital_encounters, :weight, :string
  end
end

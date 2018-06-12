class AddKeyToHospitalEncounter < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_encounters, :nation_code, :string
    add_column :hospital_encounters, :nation_display, :string
    add_column :hospital_encounters, :blood_code, :string
    add_column :hospital_encounters, :blood_display, :string
    add_column :hospital_encounters, :drugstore_location_id, :integer
    add_column :hospital_encounters, :marriage_code, :string
    add_column :hospital_encounters, :marriage_display, :string
  end
end

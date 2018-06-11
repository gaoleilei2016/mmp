class AddKey3ToHospitalEncounter < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_encounters, :person_id, :integer
  end
end

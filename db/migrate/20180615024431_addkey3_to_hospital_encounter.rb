class Addkey3ToHospitalEncounter < ActiveRecord::Migration[5.1]
  def change
  	add_column :hospital_encounters, :author_id, :integer
  end
end

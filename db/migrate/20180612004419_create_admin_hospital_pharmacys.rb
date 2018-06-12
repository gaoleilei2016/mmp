class CreateAdminHospitalPharmacys < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_hospital_pharmacys do |t|
      t.string :pharmacy_id
      t.string :hospital_id
      t.timestamps
    end
  end
end

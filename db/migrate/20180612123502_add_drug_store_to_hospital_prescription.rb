class AddDrugStoreToHospitalPrescription < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_prescriptions, :drug_store_id, :integer
  end
end

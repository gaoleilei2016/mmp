class AddKey4ToHospitalPrescription < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_prescriptions, :charger_id, :integer
    add_column :hospital_prescriptions, :charger_display, :string
    add_column :hospital_prescriptions, :charge_at, :datetime
    add_column :hospital_prescriptions, :return_charge_opt_id, :integer
    add_column :hospital_prescriptions, :return_charge_opt_display, :string
    add_column :hospital_prescriptions, :return_charge_at, :datetime
  end
end

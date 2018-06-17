class AddKey3ToHospitalPrescription < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_prescriptions, :auditor_id, :string
    add_column :hospital_prescriptions, :auditor_display, :string
    add_column :hospital_prescriptions, :audit_at, :datetime
    add_column :hospital_prescriptions, :abandonor_id, :string
    add_column :hospital_prescriptions, :abandonor_display, :string
    add_column :hospital_prescriptions, :abandon_at, :datetime
    add_column :hospital_prescriptions, :delivery_id, :string
    add_column :hospital_prescriptions, :delivery_display, :string
    add_column :hospital_prescriptions, :delivery_at, :datetime
  end
end

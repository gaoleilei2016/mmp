class AddKey3ToHospitalOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_orders, :formul_code, :string
    add_column :hospital_orders, :formul_display, :string
  end
end

class AddKey6ToHospitalOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_orders, :measure_val, :decimal
    add_column :hospital_orders, :measure_unit, :string
  end
end

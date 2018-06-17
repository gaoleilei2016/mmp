class AddKey5ToHospitalOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_orders, :factory_name, :string
    add_column :hospital_orders, :base_unit, :string
    add_column :hospital_orders, :mul, :decimal
  end
end

class AddKeyToHospitalOrder < ActiveRecord::Migration[5.1]
  def change
  	add_column :hospital_orders, :prescription_id, :integer
  end
end

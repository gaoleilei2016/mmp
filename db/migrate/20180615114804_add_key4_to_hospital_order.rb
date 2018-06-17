class AddKey4ToHospitalOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_orders, :mtemplate_id, :integer
  end
end

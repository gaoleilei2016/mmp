class AddKey2ToHospitalOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_orders, :author_id, :integer
  end
end

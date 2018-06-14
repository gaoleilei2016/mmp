class CreateRelationOrdersAndPrescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :relation_orders_and_prescriptions do |t|
      t.string :prescript_id
      t.string :order_id

      t.timestamps
    end
  end
end

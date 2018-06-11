class CreateOrdersOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :orders_order_details do |t|
      t.string :item_id
      t.string :name
      t.string :order_id
      t.float :quantity
      t.string :unit
      t.string :specifications
      t.string :dosage
      t.float :price
      t.float :net_amt
      t.string :img_path

      t.timestamps
    end
  end
end

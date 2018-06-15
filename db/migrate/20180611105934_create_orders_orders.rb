class CreateOrdersOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders_orders do |t|
      t.time :payment_at
      t.time :end_time
      t.time :close_time
      t.string :target_org_ii
      t.string :target_org_name
      t.string :source_org_ii
      t.string :source_org_name
      t.string :order_code
      t.string :user_id
      t.string :person_id
      t.string :doctor
      t.string :shipping_name
      t.string :shipping_code
      t.float :payment_type
      t.string :status

      t.timestamps
    end
  end
end

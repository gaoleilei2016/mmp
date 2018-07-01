class ChangeOrdersOrders < ActiveRecord::Migration[5.1]
  def change
    change_table :orders_orders do |t|
      t.integer :order_failure_time,comment:'订单失效时间'
    end
  end
end
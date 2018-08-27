class ChangeOrdersOrders2 < ActiveRecord::Migration[5.1]
  def change
    change_table :orders_orders do |t|
      t.integer :lock_version,comment:'乐观锁的锁版本号'
    end
  end
end
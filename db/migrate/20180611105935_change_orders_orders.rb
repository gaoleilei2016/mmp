class ChangeOrdersOrders < ActiveRecord::Migration[5.1]
  def change
    change_table :orders_order_details do |t|
      t.time :refund_medical_time,comment:'退药时间'
      t.string :refund_medical_reason,default:'',comment:'退药原因'
    end
  end
end
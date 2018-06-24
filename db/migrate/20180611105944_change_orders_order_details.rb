class ChangeOrdersOrderDetails < ActiveRecord::Migration[5.1]
  def change
    change_table :orders_order_details do |t|
      t.string :prescription_id,default:'',comment:'处方id'
    end
  end
end

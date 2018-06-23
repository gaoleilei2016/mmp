class CreateOrdersOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :orders_order_details do |t|
      t.string :item_id,default:'',comment:'商品id'
      t.string :name,default:'',comment:'商品名字'
      t.string :order_id,default:'',comment:'订单id'
      t.float :quantity,default:0.0,comment:'数量'
      t.string :unit,default:'',comment:'单位'
      t.string :specifications,default:'',comment:'规格'
      t.string :dosage,default:'',comment:'剂型'
      t.float :price,default:0.0,comment:'单价'
      t.float :net_amt,default:0.0,comment:'总价'
      t.string :persecipt_id,default:'',comment:'处方id'
      t.string :img_path,default:'',comment:'图片'
      t.string :firm,default:'',comment:'厂家'

      t.timestamps
    end
  end
end
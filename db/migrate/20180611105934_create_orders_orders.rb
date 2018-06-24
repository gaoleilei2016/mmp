class CreateOrdersOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders_orders do |t|
      t.time :payment_at ,comment:'支付时间'
      t.time :end_time , comment:'订单完成时间'
      t.time :close_time ,comment:'订单关闭时间'
      t.string :target_org_id , default:'',comment:'药店id'
      t.string :target_org_name , default:'',comment:'药店name'
      t.string :source_org_id , default:'',comment:'医院id'
      t.string :source_org_name , default:'',comment:'医院name'
      t.string :order_code , default:'',comment:'订单号'
      t.string :user_id , default:'',comment:'用户id'
      t.string :person_id , default:'',comment:'患者id'
      t.string :doctor , default:'',comment:'开单医生'
      t.string :shipping_name , default:'',comment:'物流名称'
      t.string :shipping_code , default:'',comment:'物流单号'
      t.integer :payment_type , default:0,comment:'支付类别,1.在线支付,2.线下支付'
      t.string :status , default:'',comment:'订单状态：1待付款,2收讫,3未发货,4已发货,5交易完成,6已退药,7交易关闭'
      t.string :patient_name , default:'',comment:'患者名字'
      t.string :patient_phone , default:'',comment:'患者手机'
      t.string :drug_user , default:'',comment:'发药人'
      t.string :drug_user_id , default:'',comment:'发药人id'
      t.string :patient_sex , default:'',comment:'患者性别'
      t.string :patient_age , default:'',comment:'年龄'
      t.string :patient_iden , default:'',comment:'身份证'
      t.string :pay_type , default:'',comment:'支付类型,Alipay ,Wechat'
      t.string :reason , default:'',comment:'退费退药原因'
      t.integer :_locked , default:0,comment:'锁标记'
      t.string :invoice_id , default:'',comment:'发票id'
      t.integer :settle_times , default:0,comment:'结算次数'
      t.integer :is_send_medical , default:0,comment:'是否发药'
      t.timestamps
    end
  end
end
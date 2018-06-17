class PayOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :pay_orders do |t|
      t.column :cost_name,    :string,  default: ''
      t.column :out_trade_no, :string,  default: ''
      t.column :trade_type,   :string,  default: ''
      t.column :pay_type,     :string,  default: ''
      t.column :total_fee,    :decimal, precision: 15, scale: 2
      t.column :title,        :string,  default: ''
      t.column :return_url,   :string,  default: ''
      t.column :openid,       :string,  default: ''
      t.column :status,       :string,  default: ''
      t.column :status_desc,  :string,  default: ''

      t.timestamps
    end
  end
end

class PayAlipays < ActiveRecord::Migration[5.1]
  def change
    create_table :pay_alipays do |t|
      t.column :cost_name,    :string, default: ''
      t.column :out_trade_no, :string, default: ''
      t.column :total_fee,    :float,  default: 0.0
      t.column :title,        :string, default: ''
      t.column :return_url,   :string, default: ''
      t.column :status,       :string, default: ''
      t.column :status_desc,  :string, default: ''

      t.timestamps
    end
  end
end

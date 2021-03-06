class PayRefunds < ActiveRecord::Migration[5.1]
  # out_refund_no,refund_fee,status,status_desc
  def change
    create_table :pay_refunds do |t|
      t.column :order_id,      :integer
      t.column :reason,        :string,  default: ''
      t.column :out_refund_no, :string,  default: ''
      t.column :refund_fee,    :decimal, precision: 15, scale: 2
      t.column :status,        :string,  default: ''
      t.column :status_desc,   :string,  default: ''

      t.timestamps
    end
  end
end

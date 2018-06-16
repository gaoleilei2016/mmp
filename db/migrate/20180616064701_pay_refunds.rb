class PayRefunds < ActiveRecord::Migration[5.1]
  # out_refund_no,refund_fee,status,status_desc
  def change
    create_table :pay_refunds do |t|
      t.column :cost_name,    :string, default: ''
      t.column :out_refund_no, :string, default: ''
      t.column :refund_fee,    :float,  default: 0.0
      t.column :title,        :string, default: ''
      t.column :status,       :string, default: ''
      t.column :status_desc,  :string, default: ''

      t.timestamps
    end
  end
end

class CreateOrderHeaders < ActiveRecord::Migration[5.1]
  def change
    create_table :order_headers do |t|
      t.string :source_org_ii
      t.string :source_org_name

      t.timestamps
    end
  end
end

class CreateImsOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_orders do |t|
      t.string :org_ii
      t.string :org_name
      t.string :source_org_ii
      t.string :source_org_name
      t.string :target_org_ii
      t.string :target_org_name
      t.string :patient_order_id
      t.string :order_code
      t.string :author_name
      t.string :patient_name
      t.integer :repeat_number
      t.float :total_amount
      t.string :search_name
      t.string :note
      t.string :operater_id
      t.string :operater_name
      t.datetime :operat_at
      t.string :ori_id
      t.string :ori_code
	    t.boolean :this_returned
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end

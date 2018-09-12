class CreateImsInvStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_inv_stocks do |t|
      t.integer :org_id
      t.integer :medicine_id
      t.string :pt_code
      t.string :code
      t.string :unit
      t.float :price
      t.string :mul
      t.string :batch
      t.string :location_id
      t.string :location_name
      t.float :quantity
      t.float :freeze_qty
      t.float :amount
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end

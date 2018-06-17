class CreateImsSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_settings do |t|
      t.string :org_ii
      t.string :org_name
      t.integer :returned_at
      t.integer :payment_expired
      t.integer :unpaid_expired

      t.timestamps
    end
  end
end

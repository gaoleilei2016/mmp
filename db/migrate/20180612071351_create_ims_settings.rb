class CreateImsSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_settings do |t|
      t.string :ii_root
      t.integer :returned_at
      t.integer :payment_Expired
      t.integer :unpaid_expired

      t.timestamps
    end
  end
end

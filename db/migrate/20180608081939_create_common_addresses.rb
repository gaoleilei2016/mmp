class CreateCommonAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :common_addresses do |t|
      t.string :use
      t.string :type
      t.string :province
      t.string :city
      t.string :country
      t.string :township
      t.string :street
      t.string :house_number
      t.string :post_code
      t.string :detail
      t.string :period_start
      t.string :period_end
      t.string :status
      t.integer :master_id

      t.timestamps
    end
  end
end

class CreateCustomerSearchHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_search_histories do |t|
      t.string :pharmacy_id
      t.string :user_id
      t.timestamps
    end
    change_table :customer_search_histories do |t|
      t.integer :use_count
    end
  end
end

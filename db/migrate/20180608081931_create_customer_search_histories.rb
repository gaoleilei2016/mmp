class CreateCustomerSearchHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_search_histories do |t|
      t.string :use_count
      t.string :pharmacy_id
      t.string :user_id
      t.timestamps
    end
  end
end

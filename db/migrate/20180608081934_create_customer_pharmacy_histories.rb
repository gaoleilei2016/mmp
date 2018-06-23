class CreateCustomerPharmacyHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_pharmacy_histories do |t|
      t.string :pharmacy_id
      t.string :user_id
      t.integer :use_count
      t.timestamps
    end
    change_table :customer_pharmacy_histories do |t|
      t.string :use_type
      t.column :lat,:double
      t.column :lng,:double
    end
  end
end

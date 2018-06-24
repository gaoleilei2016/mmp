class CreateCustomerFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_feedbacks do |t|
      t.string :user_id
      t.string :content
      t.string :contact
      t.string :score
      t.timestamps
    end
    change_table :customer_feedbacks do |t|
      t.string :reply
    end
  end
end

class AddWowgoToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.boolean :wowgo
    end
  end
end
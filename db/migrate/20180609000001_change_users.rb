class ChangeUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.string :name
      t.string :jianpin
      t.string :type_code
      t.string :organization_id
      t.string :sex
      t.string :birth
    end
  end
end

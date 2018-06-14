class AddKeyToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :blood_code, :string
    add_column :people, :blood_display, :string
    add_column :people, :height, :float
    add_column :people, :weight, :float
  end
end

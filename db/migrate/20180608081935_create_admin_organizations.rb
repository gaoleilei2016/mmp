class CreateAdminOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_organizations do |t|
      # t.string :ii_root
      t.string :type_code
      t.string :name
      t.string :jianpin
      t.timestamps
    end
    change_table :admin_organizations do |t|
      t.string :addr
      t.column :lat,:double
      t.column :lng,:double
      t.boolean :yaofang_type
      t.integer :search_count
    end
  end
end
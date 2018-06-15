class CreateAdminOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_organizations do |t|
      t.string :type_code
      t.string :name
      t.string :jianpin
      t.timestamps
      t.string :addr
      t.column :lat, :double
      t.column :lng, :double
    end
    # change_table :admin_organizations do |t|
    # end
  end
end

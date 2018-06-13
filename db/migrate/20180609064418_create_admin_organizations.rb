class CreateAdminOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_organizations do |t|
      # t.string :ii_root
      t.string :type_code
      t.string :name
      t.string :jianpin

      t.timestamps
    end
  end
end

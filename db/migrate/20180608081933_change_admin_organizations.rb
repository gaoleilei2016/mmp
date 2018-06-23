class ChangeAdminOrganizations < ActiveRecord::Migration[5.1]
  def change
    change_table :admin_organizations do |t|
      t.integer :search_count
    end
  end
end
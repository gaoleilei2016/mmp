class CreateImsInvRefreshLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_inv_refresh_logs do |t|
      t.string :peson
      t.string :person_code
      t.string :org_id
      t.string :medicine_id
      t.integer :refresh_befor_num
      t.integer :refresh_after_num
      t.string :update_PCIP
      t.integer :status

      t.timestamps
    end
  end
end

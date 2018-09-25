class CreateImsInvSelectConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_inv_select_configs do |t|
      t.string :use_org_id
      t.integer :c_id
      t.string :use_name

      t.timestamps
    end
  end
end

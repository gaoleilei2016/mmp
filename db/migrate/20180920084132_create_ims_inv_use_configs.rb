class CreateImsInvUseConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_inv_use_configs do |t|
      t.string :use_system
      t.string :configstr

      t.timestamps
    end
  end
end

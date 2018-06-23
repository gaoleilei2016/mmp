class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :login
      t.timestamps
    end
    change_table :users do |t|
      t.string :name
      t.string :jianpin
      t.string :type_code
      t.string :organization_id
      t.string :sex
      t.string :birth
      t.string :headimgurl
      t.string :admin_level
      t.string :openid
      t.string :openname
    end
    change_table :users do |t|
      t.string :cur_loc_id
      t.string :cur_loc_display
    end
  end
end
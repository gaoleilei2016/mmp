class PositionDatas < ActiveRecord::Migration[5.1]
  def change
    create_table :position_datas do |t|
      t.column :name,  :string,  default: ''
      t.column :title, :string,  default: ''
      t.column :lat,   :double
      t.column :lng,   :double
      
      t.timestamps
    end
  end
end

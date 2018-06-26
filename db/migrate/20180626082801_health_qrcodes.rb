class HealthQrcodes < ActiveRecord::Migration[5.1]
  def change
    create_table :health_qrcodes do |t|
      t.column :code,     :string,    default: ''
      t.column :img_data, :binary
      t.column :text,     :string,    default: ''
      t.column :img_type, :string,    default: ''
      t.column :status,   :string,    default: ''

      t.timestamps
    end
  end
end

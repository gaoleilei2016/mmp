class HealthWowgos < ActiveRecord::Migration[5.1]
  def change
    create_table :health_wowgos do |t|
      t.column :api_code,    :string, default: ''
      t.column :user_name,   :string, default: ''
      t.column :gender,      :string, default: ''
      t.column :height,      :string, default: ''
      t.column :birth,       :string, default: ''
      t.column :headimgurl,  :string, default: ''
      t.column :qrcode_text, :string, default: ''
      t.column :userid,      :string, default: ''
      t.column :return_code, :string, default: ''
      t.column :return_msg,  :string, default: ''

      t.timestamps
    end
  end
end

class CreateSmsMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :sms_messages do |t|
      t.column :phone,      :string, default: ''
      t.column :name,       :string, default: ''
      t.column :code,       :string, default: ''
      t.column :expired_in, :string, default: ''
      t.column :data_type,  :string, default: ''

      t.timestamps
    end

    add_index :sms_messages, :phone
  end
end

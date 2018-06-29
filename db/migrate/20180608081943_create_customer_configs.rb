class CreateCustomerConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_configs do |t|
      t.string :user_id # 
      t.string :ii # 唯一识别标识, 建议按系统前缀命名
      t.boolean :flag # 
      t.string :info # 标识说明
    end
  end
end
class CreateFapiaoTaitous < ActiveRecord::Migration[5.1]
  def change
    create_table :fapiao_taitous do |t|
      t.string :default # 默认
      t.string :user_id
      t.string :name # 名称
      t.string :shuihao # 税号
      t.string :addr # 企业地址
      t.string :telephone # 电话号码
      t.string :bank # 开户行
      t.string :bank_num # 银行账号
      t.timestamps
    end
    change_table :fapiao_taitous do |t|
      t.string :type_code # 企业1 / 个人2
    end
  end
end

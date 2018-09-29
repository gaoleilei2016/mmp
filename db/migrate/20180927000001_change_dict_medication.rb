class ChangeDictMedication < ActiveRecord::Migration[5.1]
	def change
		change_table :dictmedicine do |t|
      		t.boolean :return_price_flag, comment: "返款标记"
      		t.string :pharmacology_code, limit: 10, comment: "药理学分类编码 编码系统: 2.16.156.1.675425699.1.255"
      		t.string :indications, limit: 255, comment: "适应症 数据格式用|分割 例如：感冒|头疼|发烧 编码系统: 2.16.156.1.675425699.1.256"
    	end
	end
end
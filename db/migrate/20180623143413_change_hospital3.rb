class ChangeHospital3 < ActiveRecord::Migration[5.1]
	def change
		change_table :hospital_orders do |t|
      		t.integer :rank_in_prescription, limit: 3,comment: "医嘱在处方中的顺序"
    	end
	end
end
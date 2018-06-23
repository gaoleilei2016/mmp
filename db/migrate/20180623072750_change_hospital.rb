class ChangeHospital < ActiveRecord::Migration[5.1]
	def change
		remove_column :hospital_prescriptions, :is_read
		change_table :hospital_prescriptions do |t|
      		t.boolean :is_read, default: 0, comment: "用户处方是否已读"
    	end
		change_column :hospital_diagnoses, :type_code, :string
	end
end
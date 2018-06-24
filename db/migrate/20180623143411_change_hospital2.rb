class ChangeHospital2 < ActiveRecord::Migration[5.1]
	def change
		remove_column :people, :photo
		change_table :people do |t|
      		t.text :photo, comment: "照片"
    	end
	end
end
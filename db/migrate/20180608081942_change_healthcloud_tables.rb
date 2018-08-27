class ChangeHealthcloudTables < ActiveRecord::Migration[5.1]
	def change
		# # 3
		# create_table :health_cloud_ws_diets do |t|
		# 	t.integer :intServerID
		# 	t.string :datRecordTime
		# 	t.string :intDietType
		# 	t.string :img1
		# 	t.string :img2
		# 	t.string :img3
		# 	t.string :img4
		# 	t.string :img5
		# 	t.string :img6
		# 	t.string :img7
		# 	t.string :img8
		# 	t.string :img9
		# 	t.string :strMemo
		# 	t.string :userid
		# 	t.string :strPrgID
		# 	t.string :strUserAccount
		# 	t.timestamps
		# end
		# # 6
		# create_table :health_cloud_ws_hearts do |t|
		# 	t.integer :intServerID
		# 	t.string :datRecordTime
		# 	t.string :strHR
		# 	t.string :strMemo
		# 	t.string :userid
		# 	t.string :strPrgID
		# 	t.string :strUserAccount
		# 	t.timestamps
		# end
		change_column :health_cloud_ws_diets, :intServerID, :integer
		change_column :health_cloud_ws_diets, :datRecordTime, :string
		change_column :health_cloud_ws_diets, :intDietType, :string
		change_column :health_cloud_ws_diets, :img1, :string
		change_column :health_cloud_ws_diets, :img2, :string
		change_column :health_cloud_ws_diets, :img3, :string
		change_column :health_cloud_ws_diets, :img4, :string
		change_column :health_cloud_ws_diets, :img5, :string
		change_column :health_cloud_ws_diets, :img6, :string
		change_column :health_cloud_ws_diets, :img7, :string
		change_column :health_cloud_ws_diets, :img8, :string
		change_column :health_cloud_ws_diets, :img9, :string
		change_column :health_cloud_ws_diets, :strMemo, :string
		change_column :health_cloud_ws_diets, :userid, :string
		change_column :health_cloud_ws_diets, :strPrgID, :string
		change_column :health_cloud_ws_diets, :strUserAccount, :string
		
		change_column :health_cloud_ws_hearts, :intServerID, :integer
		change_column :health_cloud_ws_hearts, :datRecordTime, :string
		change_column :health_cloud_ws_hearts, :strHR, :string
		change_column :health_cloud_ws_hearts, :strMemo, :string
		change_column :health_cloud_ws_hearts, :userid, :string
		change_column :health_cloud_ws_hearts, :strPrgID, :string
		change_column :health_cloud_ws_hearts, :strUserAccount, :string
	end
end

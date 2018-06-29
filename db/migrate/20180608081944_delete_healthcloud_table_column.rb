class DeleteHealthcloudTableColumn < ActiveRecord::Migration[5.1]
	def change
		remove_column :health_cloud_ws_bloods, :created_at
		remove_column :health_cloud_ws_blood_sugars, :created_at
		remove_column :health_cloud_ws_diets, :created_at
		remove_column :health_cloud_ws_ecg_breaths, :created_at
		remove_column :health_cloud_ws_ecg_hearts, :created_at
		remove_column :health_cloud_ws_hearts, :created_at
		remove_column :health_cloud_ws_heart_vts, :created_at
		remove_column :health_cloud_ws_logs, :created_at
		remove_column :health_cloud_ws_members, :created_at
		remove_column :health_cloud_ws_questions, :created_at
		remove_column :health_cloud_ws_rings, :created_at
		remove_column :health_cloud_ws_sleeps, :created_at
		remove_column :health_cloud_ws_sleep_vts, :created_at
		remove_column :health_cloud_ws_sports, :created_at
		remove_column :health_cloud_ws_sys, :created_at
		remove_column :health_cloud_ws_users, :created_at
		remove_column :health_cloud_ws_weights, :created_at
		
		remove_column :health_cloud_ws_bloods, :updated_at
		remove_column :health_cloud_ws_blood_sugars, :updated_at
		remove_column :health_cloud_ws_diets, :updated_at
		remove_column :health_cloud_ws_ecg_breaths, :updated_at
		remove_column :health_cloud_ws_ecg_hearts, :updated_at
		remove_column :health_cloud_ws_hearts, :updated_at
		remove_column :health_cloud_ws_heart_vts, :updated_at
		remove_column :health_cloud_ws_logs, :updated_at
		remove_column :health_cloud_ws_members, :updated_at
		remove_column :health_cloud_ws_questions, :updated_at
		remove_column :health_cloud_ws_rings, :updated_at
		remove_column :health_cloud_ws_sleeps, :updated_at
		remove_column :health_cloud_ws_sleep_vts, :updated_at
		remove_column :health_cloud_ws_sports, :updated_at
		remove_column :health_cloud_ws_sys, :updated_at
		remove_column :health_cloud_ws_users, :updated_at
		remove_column :health_cloud_ws_weights, :updated_at
	end
end

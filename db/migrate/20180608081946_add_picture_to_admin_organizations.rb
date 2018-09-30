class AddPictureToAdminOrganizations < ActiveRecord::Migration[5.1]
	def change
		change_table :admin_organizations do |t|
			t.binary :picture
		end
	end
end

class AddKeyToHospitalPrescription < ActiveRecord::Migration[5.1]
	def change
		add_column :hospital_prescriptions, :is_read, :boolean
	end
end
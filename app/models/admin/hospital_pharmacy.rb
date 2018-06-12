class Admin::HospitalPharmacy < ApplicationRecord
	self.table_name = 'admin_hospital_pharmacys'
	belongs_to :pharmacy,class_name:"Admin::Organization",foreign_key:"pharmacy_id"
	belongs_to :hospital,class_name:"Admin::Organization",foreign_key:"hospital_id"
end

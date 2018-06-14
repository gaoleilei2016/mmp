class Admin::Organization < ApplicationRecord
	has_many :users,class_name:"User"
	has_many :pharmacy_link,class_name:"Admin::HospitalPharmacy",foreign_key:"hospital_id"
	has_many :hospital_link,class_name:"Admin::HospitalPharmacy",foreign_key:"pharmacy_id"
	validate do
		errors.add(:type_code,"type_code=>#{type_code}:#{type_code.class} 取值必须在 [ '1','2' ]") unless ['1','2'].index(self.type_code)
	end
end

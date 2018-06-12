class ChangeKeyToHospitalPrescription < ActiveRecord::Migration[5.1]
  def change
  	change_table :hospital_prescriptions do |t|
	    t.rename :code, :type_code
	    t.string :type_display, comment: "处分类型名称"
	    t.rename :confidentiality, :confidentiality_code
	    t.string :confidentiality_display, comment: " 权限描述"
	    t.string :prescription_no, comment: "处方号"
    end
  end
end

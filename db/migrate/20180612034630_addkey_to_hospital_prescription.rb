class AddkeyToHospitalPrescription < ActiveRecord::Migration[5.1]
  def change
  	change_table :hospital_prescriptions do |t|
  		t.boolean :specialmark, default:false, comment: '特殊处方标记'
  	end
  end
end

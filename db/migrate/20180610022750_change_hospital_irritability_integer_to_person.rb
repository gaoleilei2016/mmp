class ChangeHospitalIrritabilityIntegerToPerson < ActiveRecord::Migration[5.1]
  def change
  	change_table :hospital_irritabilities do |t|
	  t.rename :integer, :person_id
	end
  end
end

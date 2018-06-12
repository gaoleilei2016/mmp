module ::Hospital::Interface
	# => 根据电话号获取处方单
	def self.get_prescription(phone)
		::Hospital::Prescription.find_by_sql("SELECT b.* FROM hospital_prescriptions a INNER JOIN  hospital_encounters b on a.encounter_id=b.id WHERE b.phone=#{phone}")
	end
end
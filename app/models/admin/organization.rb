class Admin::Organization < ApplicationRecord
	validate do
		errors.add(:type_code,"type_code=>#{type_code}:#{type_code.class} 取值必须在 [ '1','2' ]") unless ['1','2'].index(self.type_code)
	end
end

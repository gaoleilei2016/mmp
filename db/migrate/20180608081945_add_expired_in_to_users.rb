class AddExpiredInToUsers < ActiveRecord::Migration[5.1]
	def change
		change_table :users do |t|
			t.string :expired_in
		end
	end
end

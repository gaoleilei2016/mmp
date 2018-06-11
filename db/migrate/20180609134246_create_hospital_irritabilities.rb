class CreateHospitalIrritabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_irritabilities do |t|
      t.string :code
      t.string :display
      t.string :system
      t.string :status
      t.string :period_start
      t.string :datetime
      t.string :data_entry_id
      t.string :person_id

      t.timestamps
    end
  end
end

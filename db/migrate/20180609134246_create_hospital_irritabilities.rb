class CreateHospitalIrritabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_irritabilities do |t|
      t.string :code
      t.string :string
      t.string :display
      t.string :string
      t.string :system
      t.string :string
      t.string :status
      t.string :string
      t.string :period_start
      t.string :datetime
      t.string :data_entry_id
      t.string :integer

      t.timestamps
    end
  end
end

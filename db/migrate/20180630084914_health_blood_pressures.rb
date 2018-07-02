class HealthBloodPressures < ActiveRecord::Migration[5.1]
  def change
    create_table :health_blood_pressures do |t|
      t.column :user_id, :integer
      t.column :code,            :string, default: ''
      t.column :systolic_value,  :integer
      t.column :diastolic_value, :integer
      t.column :state,           :string, default: ''
      t.column :state_desc,      :string, default: ''

      t.timestamps
    end
  end
end

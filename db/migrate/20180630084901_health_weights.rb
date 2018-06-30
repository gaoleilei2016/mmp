class HealthWeights < ActiveRecord::Migration[5.1]
  def change
    create_table :health_weights do |t|
      t.column :user_id
      t.column :sex,               :string, default: ''
      t.column :age,               :integer
      t.column :bmi,               :string, default: ''
      t.column :height,            :string, default: ''
      t.column :code,              :string, default: ''
      t.column :data,              :string, default: ''
      t.column :max_heart_rate,    :string, default: ''
      t.column :normal_heart_rate, :string, default: ''

      t.timestamps
    end
  end
end

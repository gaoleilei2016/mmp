class CreateHospitalOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :hospital_orders do |t|
      t.integer :serialno
      t.string :title
      t.string :specification
      t.float :single_qty_value
      t.string :single_qty_unit
      t.float :dose_value
      t.string :dose_unit
      t.string :route_code
      t.string :route_display
      t.string :frequency_code
      t.string :frequency_display
      t.integer :course_of_treatment_value
      t.string :course_of_treatment_unit, default: '天'
      t.float :total_quantity
      t.string :unit
      t.float :price
      t.string :note
      t.string :status
      t.integer :order_type, default: 1
      t.integer :encounter_id

      t.timestamps
    end
  end
end

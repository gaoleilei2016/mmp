class CreateImsPrescriptionDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :ims_prescription_details do |t|
      t.integer :drug_id
      t.string :title
      t.string :specification
      t.string :single_qty_value
      t.string :single_qty_unit
      t.string :dose_value
      t.string :dose_unit
      t.string :route_value
      t.string :route_unit
      t.string :frequency_code
      t.string :frequency_display
      t.string :course_of_treatment_value
      t.string :course_of_treatment_unit
      t.string :formul_code
      t.string :formul_display
      t.float :qty
      t.float :send_qty
      t.float :return_qty
      t.string :unit
      t.string :price
      t.float :amount
      t.string :note
      t.string :status
      t.string :order_type
      t.string :encounter_id
      t.string :author_id
      t.string :author_name
      t.string :factory_name
      t.string :base_unit
      t.string :mul
      t.string :measure_val
      t.string :measure_unit
      t.string :type_type
      t.string :status
      t.integer :hospital_prescription_order_id

      t.timestamps
    end
  end
end
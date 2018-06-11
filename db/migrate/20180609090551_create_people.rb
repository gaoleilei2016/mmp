class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :health_file_no
      t.string :iden
      t.string :health_card_no
      t.string :name
      t.datetime :birth_date
      t.integer :age
      t.string :gender_code
      t.string :gender_display
      t.string :nationality_code
      t.string :nationality_display
      t.string :home_town_province
      t.string :home_town_city
      t.string :nation_code
      t.string :nation_display
      t.string :marriage_code
      t.string :marriage_display
      t.string :education_code
      t.string :education_display
      t.string :occupation_code
      t.string :occupation_display
      t.string :phone
      t.string :email
      t.string :pa_post_code
      t.string :pa_address
      t.string :ha_post_code
      t.string :ha_address
      t.string :unit_name
      t.string :unit_phone
      t.string :ua_post_code
      t.string :ua_address
      t.string :contact_name
      t.string :contact_relation_code
      t.string :contact_relation_display
      t.string :contact_phone
      t.string :ca_post_code
      t.string :ca_address
      t.datetime :input_date
      t.string :input_organ_code
      t.string :input_organ_name
      t.string :input_name

      t.timestamps
    end
  end
end

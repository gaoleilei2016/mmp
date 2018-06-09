# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180609090551) do

  create_table "admin_organizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type_code"
    t.string "name"
    t.string "jianpin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "common_addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "use"
    t.string "type"
    t.string "province"
    t.string "city"
    t.string "country"
    t.string "township"
    t.string "street"
    t.string "house_number"
    t.string "post_code"
    t.string "detail"
    t.string "period_start"
    t.string "period_end"
    t.string "status"
    t.integer "master_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "health_file_no"
    t.string "iden"
    t.string "health_card_no"
    t.string "name"
    t.datetime "birth_date"
    t.integer "age"
    t.string "gender_code"
    t.string "gender_display"
    t.string "nationality_code"
    t.string "nationality_display"
    t.string "home_town_province"
    t.string "home_town_city"
    t.string "nation_code"
    t.string "nation_display"
    t.string "marriage_code"
    t.string "marriage_display"
    t.string "education_code"
    t.string "education_display"
    t.string "occupation_code"
    t.string "occupation_display"
    t.string "phone"
    t.string "email"
    t.string "pa_post_code"
    t.string "pa_address"
    t.string "ha_post_code"
    t.string "ha_address"
    t.string "unit_name"
    t.string "unit_phone"
    t.string "ua_post_code"
    t.string "ua_address"
    t.string "contact_name"
    t.string "contact_relation_code"
    t.string "contact_relation_display"
    t.string "contact_phone"
    t.string "ca_post_code"
    t.string "ca_address"
    t.datetime "input_date"
    t.string "input_organ_code"
    t.string "input_organ_name"
    t.string "input_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

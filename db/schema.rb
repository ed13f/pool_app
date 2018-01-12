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

ActiveRecord::Schema.define(version: 20180112054410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", force: :cascade do |t|
    t.string "owners_first_name"
    t.string "owners_last_name"
    t.string "business_name"
    t.string "phone", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone", null: false
    t.string "email", null: false
    t.string "street_address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.string "gate_code"
    t.string "service_day"
    t.string "filter_type"
    t.string "pump_type"
    t.float "latitude"
    t.float "longitude"
    t.integer "user_id", null: false
    t.integer "visit_per_week", default: 1
    t.boolean "weekly_complete", default: false
    t.boolean "spa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "days", force: :cascade do |t|
    t.string "monday"
    t.string "tuesday"
    t.string "wednesday"
    t.string "thursday"
    t.string "friday"
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer "repair_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "notes", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repairs", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.boolean "complete", default: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "admin", null: false
    t.integer "business_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visits", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "customer_id", null: false
    t.integer "chlorine"
    t.integer "ph"
    t.integer "alkalinity"
    t.integer "stabilizer"
    t.integer "salt"
    t.boolean "clean_tile"
    t.boolean "leaf_net"
    t.boolean "vacuum"
    t.boolean "brush"
    t.boolean "skimmer_basket"
    t.boolean "pump_basket"
    t.boolean "clean_filters"
    t.boolean "new_filters"
    t.boolean "add_chlorine"
    t.boolean "add_acid"
    t.boolean "add_bicarb"
    t.boolean "add_stabilizer"
    t.boolean "add_chlorine_tab"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

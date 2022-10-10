# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_10_200832) do
  create_table "deadlines", force: :cascade do |t|
    t.integer "min_distance"
    t.integer "max_distance"
    t.integer "deadline"
    t.integer "shipping_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_option_id"], name: "index_deadlines_on_shipping_option_id"
  end

  create_table "detailed_orders", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "shipping_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_price"
    t.datetime "estimated_delivery_date"
    t.integer "vehicle_id", null: false
    t.index ["order_id"], name: "index_detailed_orders_on_order_id"
    t.index ["shipping_option_id"], name: "index_detailed_orders_on_shipping_option_id"
    t.index ["vehicle_id"], name: "index_detailed_orders_on_vehicle_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "delivery_address"
    t.string "delivery_city"
    t.string "delivery_state"
    t.string "delivery_postal_code"
    t.string "recipient"
    t.string "recipient_cpf"
    t.string "recipient_email"
    t.string "recipient_phone_number"
    t.string "pick_up_address"
    t.string "pick_up_city"
    t.string "pick_up_state"
    t.string "pick_up_postal_code"
    t.string "sku"
    t.integer "height"
    t.integer "width"
    t.integer "length"
    t.integer "weight"
    t.integer "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.string "tracking_code"
  end

  create_table "prices", force: :cascade do |t|
    t.integer "min_weight"
    t.integer "max_weight"
    t.decimal "price_per_km"
    t.integer "shipping_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_option_id"], name: "index_prices_on_shipping_option_id"
  end

  create_table "shipping_options", force: :cascade do |t|
    t.string "name"
    t.integer "min_distance"
    t.integer "max_distance"
    t.integer "min_weight"
    t.integer "max_weight"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "delivery_fee"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.integer "shipping_option_id", null: false
    t.string "license_plate"
    t.string "brand"
    t.string "car_model"
    t.string "manufacture_year"
    t.integer "max_weight"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_option_id"], name: "index_vehicles_on_shipping_option_id"
  end

  add_foreign_key "deadlines", "shipping_options"
  add_foreign_key "detailed_orders", "orders"
  add_foreign_key "detailed_orders", "shipping_options"
  add_foreign_key "detailed_orders", "vehicles"
  add_foreign_key "prices", "shipping_options"
  add_foreign_key "vehicles", "shipping_options"
end

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

ActiveRecord::Schema.define(version: 2023_01_21_163544) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "agents", force: :cascade do |t|
    t.string "birthday", default: ""
    t.string "address", default: ""
    t.string "city", default: ""
    t.string "state", default: ""
    t.string "zip_code", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "broker_id"
    t.integer "user_id"
    t.index ["broker_id"], name: "index_agents_on_broker_id"
    t.index ["user_id"], name: "index_agents_on_user_id"
  end

  create_table "brokers", force: :cascade do |t|
    t.string "company_name", default: ""
    t.string "company_licence", default: ""
    t.integer "years_in_bussiness"
    t.string "insurance_carrier", default: ""
    t.string "insurance_policy", default: ""
    t.string "licence", default: ""
    t.date "licencia_expiration_date"
    t.string "reserver_zip_code", default: ""
    t.string "birthday", default: ""
    t.string "address", default: ""
    t.string "city", default: ""
    t.string "state", default: ""
    t.boolean "director"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.float "latitude"
    t.float "longitude"
    t.index ["latitude", "longitude"], name: "index_brokers_on_latitude_and_longitude"
    t.index ["user_id"], name: "index_brokers_on_user_id"
  end

  create_table "property_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "referrals", force: :cascade do |t|
    t.string "budget_min"
    t.string "budget_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "time_frame_id"
    t.integer "type_of_ref_id"
    t.integer "source_id"
    t.index ["source_id"], name: "index_referrals_on_source_id"
    t.index ["time_frame_id"], name: "index_referrals_on_time_frame_id"
    t.index ["type_of_ref_id"], name: "index_referrals_on_type_of_ref_id"
    t.index ["user_id"], name: "index_referrals_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_frames", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "origin_broker"
    t.integer "destination_broker"
    t.integer "origin_agent"
    t.integer "assigned_agent"
    t.string "property_address"
    t.string "contract_price"
    t.date "closing_date"
    t.string "destination_broker_commission_percent"
    t.string "destination_broker_commission"
    t.string "origin_broker_commision_percent"
    t.string "origin_broker_commission"
    t.string "proof_check"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "referred_id"
    t.integer "state_id"
    t.integer "property_type_id"
    t.integer "broker_id"
    t.integer "agent_id"
    t.index ["agent_id"], name: "index_transactions_on_agent_id"
    t.index ["broker_id"], name: "index_transactions_on_broker_id"
    t.index ["property_type_id"], name: "index_transactions_on_property_type_id"
    t.index ["referred_id"], name: "index_transactions_on_referred_id"
    t.index ["state_id"], name: "index_transactions_on_state_id"
  end

  create_table "type_of_references", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "photo"
    t.date "member_since"
    t.date "member_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

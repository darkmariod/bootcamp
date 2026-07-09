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

ActiveRecord::Schema[8.1].define(version: 2026_07_02_035632) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "alimony_calculations", force: :cascade do |t|
    t.string "applicant_name"
    t.integer "children_3_plus"
    t.integer "children_under_3"
    t.integer "claimed_children"
    t.datetime "created_at", null: false
    t.json "details"
    t.integer "disability_range"
    t.decimal "disability_supplement"
    t.boolean "iess_deducted"
    t.integer "legal_case_id"
    t.integer "level"
    t.decimal "monthly_income"
    t.decimal "pension_amount"
    t.decimal "per_child_amount"
    t.decimal "percentage"
    t.decimal "total_amount"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["legal_case_id"], name: "index_alimony_calculations_on_legal_case_id"
    t.index ["user_id"], name: "index_alimony_calculations_on_user_id"
  end

  create_table "case_notes", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "legal_case_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["legal_case_id"], name: "index_case_notes_on_legal_case_id"
    t.index ["user_id"], name: "index_case_notes_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "address"
    t.string "cedula"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.text "notes"
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  create_table "legal_cases", force: :cascade do |t|
    t.string "case_number"
    t.integer "case_type"
    t.integer "client_id", null: false
    t.string "court"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["client_id"], name: "index_legal_cases_on_client_id"
    t.index ["user_id"], name: "index_legal_cases_on_user_id"
  end

  create_table "proforma_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "proforma_id", null: false
    t.decimal "quantity"
    t.decimal "unit_price"
    t.datetime "updated_at", null: false
    t.index ["proforma_id"], name: "index_proforma_items_on_proforma_id"
  end

  create_table "proformas", force: :cascade do |t|
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.date "issued_on"
    t.integer "legal_case_id"
    t.text "notes"
    t.string "number"
    t.integer "status", default: 0
    t.decimal "total_amount"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.date "valid_until"
    t.index ["client_id"], name: "index_proformas_on_client_id"
    t.index ["legal_case_id"], name: "index_proformas_on_legal_case_id"
    t.index ["user_id"], name: "index_proformas_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "settlement_calculations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "details"
    t.date "end_date"
    t.boolean "fondos_reserva_paid"
    t.integer "legal_case_id"
    t.decimal "monthly_salary"
    t.integer "region"
    t.date "start_date"
    t.integer "termination_reason"
    t.decimal "total_amount"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "vacation_days_taken"
    t.string "worker_name"
    t.index ["legal_case_id"], name: "index_settlement_calculations_on_legal_case_id"
    t.index ["user_id"], name: "index_settlement_calculations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "alimony_calculations", "legal_cases"
  add_foreign_key "alimony_calculations", "users"
  add_foreign_key "case_notes", "legal_cases"
  add_foreign_key "case_notes", "users"
  add_foreign_key "legal_cases", "clients"
  add_foreign_key "legal_cases", "users"
  add_foreign_key "proforma_items", "proformas"
  add_foreign_key "proformas", "clients"
  add_foreign_key "proformas", "legal_cases"
  add_foreign_key "proformas", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "settlement_calculations", "legal_cases"
  add_foreign_key "settlement_calculations", "users"
end

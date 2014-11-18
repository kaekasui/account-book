# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141118033940) do

  create_table "answers", force: true do |t|
    t.integer  "user_id"
    t.integer  "feedback_id"
    t.text     "content"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "breakdowns", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "breakdowns", ["category_id"], name: "index_breakdowns_on_category_id", using: :btree
  add_index "breakdowns", ["user_id"], name: "index_breakdowns_on_user_id", using: :btree

  create_table "cancels", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cancels", ["user_id"], name: "index_cancels_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "barance_of_payments"
    t.datetime "deleted_at"
    t.integer  "user_id"
  end

  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "feedbacks", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "checked"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id", using: :btree

  create_table "monthly_counts", force: true do |t|
    t.integer  "user_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
  end

  add_index "monthly_counts", ["user_id"], name: "index_monthly_counts_on_user_id", using: :btree

  create_table "places", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "places", ["user_id"], name: "index_places_on_user_id", using: :btree

  create_table "records", force: true do |t|
    t.date     "published_at"
    t.integer  "charge"
    t.integer  "category_id"
    t.integer  "breakdown_id"
    t.integer  "place_id"
    t.text     "memo"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "records", ["breakdown_id"], name: "index_records_on_breakdown_id", using: :btree
  add_index "records", ["category_id"], name: "index_records_on_category_id", using: :btree
  add_index "records", ["place_id"], name: "index_records_on_place_id", using: :btree
  add_index "records", ["user_id"], name: "index_records_on_user_id", using: :btree

  create_table "tagged_records", force: true do |t|
    t.integer  "record_id"
    t.integer  "tag_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tagged_records", ["record_id"], name: "index_tagged_records_on_record_id", using: :btree
  add_index "tagged_records", ["tag_id"], name: "index_tagged_records_on_tag_id", using: :btree
  add_index "tagged_records", ["user_id"], name: "index_tagged_records_on_user_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.string   "color_code"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["user_id"], name: "index_tags_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "token"
    t.string   "code"
    t.boolean  "admin"
    t.string   "type"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

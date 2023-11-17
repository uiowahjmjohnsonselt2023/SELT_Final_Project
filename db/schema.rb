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

ActiveRecord::Schema.define(version: 20231116181342) do

  create_table "addresses", force: :cascade do |t|
    t.string   "shipping_address_1"
    t.string   "shipping_address_2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id"

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bookmarks", ["item_id"], name: "index_bookmarks_on_item_id"
  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: :cascade do |t|
    t.binary   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.string   "image_type"
  end

  add_index "images", ["item_id"], name: "index_images_on_item_id"

  create_table "items", force: :cascade do |t|
    t.string   "title",                                null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.decimal  "price",       precision: 10, scale: 2
  end

  add_index "items", ["user_id"], name: "index_items_on_user_id"

  create_table "items_categories", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "category_id"
  end

  add_index "items_categories", ["category_id"], name: "index_items_categories_on_category_id"
  add_index "items_categories", ["item_id"], name: "index_items_categories_on_item_id"

  create_table "payment_methods", force: :cascade do |t|
    t.string   "encrypted_card_number"
    t.string   "encrypted_card_number_iv"
    t.date     "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "payment_methods", ["user_id"], name: "index_payment_methods_on_user_id"

  create_table "purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "purchases", ["item_id"], name: "index_purchases_on_item_id", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "username",      null: false
    t.string   "email",         null: false
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.string   "provider"
    t.string   "session_token"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end

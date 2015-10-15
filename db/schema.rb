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

ActiveRecord::Schema.define(version: 20151015132348) do

  create_table "conversations", force: :cascade do |t|
    t.integer  "initiator_id", limit: 4
    t.integer  "opponent_id",  limit: 4
    t.boolean  "in_radius"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "message_type",    limit: 4
    t.string   "text",            limit: 255
    t.integer  "conversation_id", limit: 4
    t.integer  "user_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: :cascade do |t|
    t.string  "provider", limit: 255
    t.string  "uid",      limit: 255
    t.string  "avatar",   limit: 255
    t.integer "user_id",  limit: 4
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "token",        limit: 255
    t.integer  "user_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "device",       limit: 4
    t.string   "device_token", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "user_name",            limit: 255
    t.string   "first_name",           limit: 255
    t.string   "last_name",            limit: 255
    t.string   "gender",               limit: 255
    t.date     "date_of_birth"
    t.string   "encrypted_password",   limit: 255
    t.string   "salt",                 limit: 255
    t.string   "email",                limit: 255
    t.string   "avatar_file_name",     limit: 255
    t.string   "avatar_content_type",  limit: 255
    t.integer  "avatar_file_size",     limit: 4
    t.datetime "avatar_updated_at"
    t.boolean  "show_email"
    t.string   "reset_password_token", limit: 255
    t.float    "latitude",             limit: 24
    t.float    "longitude",            limit: 24
    t.datetime "location_updated_at"
  end

end

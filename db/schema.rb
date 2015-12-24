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

ActiveRecord::Schema.define(version: 20151224063026) do

  create_table "comments", force: :cascade do |t|
    t.integer  "requirement_id", limit: 4
    t.string   "name",           limit: 255
    t.string   "comment",        limit: 255
    t.string   "decision",       limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "priority_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "requirement_requirementships", force: :cascade do |t|
    t.integer  "project_id",      limit: 4
    t.integer  "requirement1_id", limit: 4
    t.integer  "requirement2_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "requirement_test_caseships", force: :cascade do |t|
    t.integer  "requirement_id", limit: 4
    t.integer  "test_case_id",   limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "requirement_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "requirements", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.text     "description",         limit: 65535
    t.integer  "owner",               limit: 4
    t.integer  "handler",             limit: 4
    t.string   "version",             limit: 255
    t.text     "memo",                limit: 65535
    t.integer  "project_id",          limit: 4
    t.integer  "requirement_type_id", limit: 4
    t.integer  "priority_type_id",    limit: 4
    t.integer  "status_type_id",      limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "status_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "test_case_test_caseships", force: :cascade do |t|
    t.integer  "test_case1_id", limit: 4
    t.integer  "test_case2_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "test_cases", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "description",     limit: 65535
    t.integer  "owner",           limit: 4
    t.integer  "asigned_as",      limit: 4
    t.text     "input_data",      limit: 65535
    t.text     "expected_result", limit: 65535
    t.boolean  "finished"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "user_project_priorities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_projectships", force: :cascade do |t|
    t.integer  "user_id",                  limit: 4
    t.integer  "project_id",               limit: 4
    t.integer  "user_project_priority_id", limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "user_projectships", ["project_id"], name: "index_user_projectships_on_project_id", using: :btree
  add_index "user_projectships", ["user_id", "project_id"], name: "index_user_projectships_on_user_id_and_project_id", unique: true, using: :btree
  add_index "user_projectships", ["user_id"], name: "index_user_projectships_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           limit: 100, null: false
    t.string   "password_digest", limit: 100, null: false
    t.string   "name",            limit: 100, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "user_projectships", "projects"
  add_foreign_key "user_projectships", "users"
end

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

ActiveRecord::Schema.define(version: 20161020084009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "features", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "icon"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position"
    t.integer  "field_id"
    t.integer  "level"
  end

  create_table "features_projects", id: false, force: :cascade do |t|
    t.integer  "feature_id"
    t.integer  "project_id"
    t.integer  "status"
    t.string   "commentaire"
    t.datetime "date_demande"
  end

  add_index "features_projects", ["feature_id", "project_id"], name: "index_features_projects_on_feature_id_and_project_id", using: :btree
  add_index "features_projects", ["feature_id"], name: "index_features_projects_on_feature_id", using: :btree
  add_index "features_projects", ["project_id"], name: "index_features_projects_on_project_id", using: :btree

  create_table "fields", force: :cascade do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "icon"
    t.integer  "parent_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "url"
    t.string   "github"
    t.integer  "workshop_id"
    t.text     "notes"
    t.integer  "etat_project"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "admin",                  default: false
    t.integer  "diploma_year"
    t.boolean  "profesor",               default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_projects", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.integer "group_id"
  end

  add_index "users_projects", ["group_id"], name: "index_users_projects_on_group_id", using: :btree
  add_index "users_projects", ["project_id"], name: "index_users_projects_on_project_id", using: :btree
  add_index "users_projects", ["user_id", "project_id"], name: "index_users_projects_on_user_id_and_project_id", using: :btree
  add_index "users_projects", ["user_id"], name: "index_users_projects_on_user_id", using: :btree

  create_table "workshops", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.string   "url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "users_projects", "groups"
end

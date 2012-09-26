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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120926010215) do

  create_table "experiment_feedbacks", :force => true do |t|
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.boolean  "experiment_failed"
    t.boolean  "instrument_failed"
    t.text     "instrument_failed_reason"
    t.text     "other_comments"
  end

  create_table "experiments", :force => true do |t|
    t.integer  "expt_id"
    t.string   "expt_name"
    t.string   "expt_type"
    t.string   "lab_book_no"
    t.string   "page_no"
    t.string   "cell_type_or_tissue"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.boolean  "slides"
    t.boolean  "dishes"
    t.boolean  "multiwell_chambers"
    t.boolean  "other"
    t.string   "other_text"
    t.boolean  "has_fluorescent_proteins"
    t.boolean  "has_specific_dyes"
    t.boolean  "has_immunofluorescence"
    t.string   "instrument"
    t.datetime "end_time"
    t.integer  "experiment_feedback_id"
  end

  add_index "experiments", ["expt_name"], :name => "index_experiments_on_expt_name"

  create_table "experiments_fluorescent_proteins", :force => true do |t|
    t.integer "experiment_id"
    t.integer "fluorescent_protein_id"
  end

  create_table "experiments_immunofluorescences", :force => true do |t|
    t.integer "experiment_id"
    t.integer "immunofluorescence_id"
  end

  create_table "experiments_specific_dyes", :force => true do |t|
    t.integer "experiment_id"
    t.integer "specific_dye_id"
  end

  create_table "fluorescent_proteins", :force => true do |t|
    t.string   "name"
    t.boolean  "core",       :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "immunofluorescences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "permissions", :force => true do |t|
    t.string   "entity"
    t.string   "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "funded_by_agency"
    t.string   "agency"
    t.string   "other_agency"
    t.integer  "user_id"
    t.integer  "supervisor_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "projects", ["name"], :name => "index_projects_on_name"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_permissions", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "permission_id"
  end

  create_table "specific_dyes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "supervisors_users", :id => false, :force => true do |t|
    t.integer "supervisor_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        :default => 0
    t.datetime "locked_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "status"
    t.integer  "role_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "user_id",                :default => "", :null => false
    t.string   "department"
    t.datetime "approved_on"
    t.text     "rejected_reason"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["user_id"], :name => "index_users_on_user_id", :unique => true

end

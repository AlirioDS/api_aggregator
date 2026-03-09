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

ActiveRecord::Schema[7.2].define(version: 2026_03_09_201313) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_statuses", force: :cascade do |t|
    t.string "full_name"
    t.string "experience"
    t.integer "pending_task_count"
    t.string "next_urgent_task"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end

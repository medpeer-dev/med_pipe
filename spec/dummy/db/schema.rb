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

ActiveRecord::Schema[7.2].define(version: 2024_11_22_022123) do
  create_table "med_pipe_pipeline_groups", force: :cascade do |t|
    t.integer "parallel_limit", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "med_pipe_pipeline_plans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "priority", default: 0, null: false
    t.string "status", null: false
    t.string "output_unit", null: false
    t.date "target_date"
    t.bigint "data_count"
    t.string "file_name"
    t.bigint "file_size"
    t.string "upload_to"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pipeline_group_id", null: false
    t.index ["pipeline_group_id"], name: "index_med_pipe_pipeline_plans_on_pipeline_group_id"
  end

  create_table "test_users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end

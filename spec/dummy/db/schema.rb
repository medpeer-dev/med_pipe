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
  create_table "med_pipe_pipeline_groups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "parallel_limit", default: 1, null: false, comment: "並列実行数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "med_pipe_pipeline_plans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false, comment: "パイプライン名"
    t.integer "priority", default: 0, null: false, comment: "実行優先度"
    t.string "status", null: false
    t.string "output_unit", null: false, comment: "実行単位. 日ごと、全て等"
    t.date "target_date", comment: "実行対象日. output_unit が daily の場合に指定"
    t.bigint "data_count"
    t.string "file_name"
    t.bigint "file_size"
    t.string "upload_to"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "pipeline_group_id", null: false
    t.index ["pipeline_group_id"], name: "index_med_pipe_pipeline_plans_on_pipeline_group_id"
  end

  create_table "test_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end

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

ActiveRecord::Schema[8.0].define(version: 2024_11_18_063336) do
  create_table "med_pipe_pipeline_plans", force: :cascade do |t|
    t.string "name", null: false
    t.string "output_unit", null: false
    t.date "target_date"
    t.string "upload_to", null: false
    t.string "status", null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer "file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end

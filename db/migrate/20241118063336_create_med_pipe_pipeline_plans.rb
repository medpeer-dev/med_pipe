# frozen_string_literal: true

class CreateMedPipePipelinePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :med_pipe_pipeline_plans do |t|
      t.string :name, null: false
      t.string :output_unit, null: false
      t.date :target_date
      t.string :upload_to, null: false
      t.string :status, null: false
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :file_size

      t.timestamps
    end
  end
end

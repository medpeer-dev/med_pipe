# frozen_string_literal: true

class CreateMedPipePipelinePlans < ActiveRecord::Migration[7.2]
  def change
    create_table :med_pipe_pipeline_plans do |t|
      t.string :name, null: false, comment: "パイプライン名"
      t.integer :priority, null: false, default: 0, comment: "実行優先度"
      t.string :status, null: false
      t.string :output_unit, null: false, comment: "実行単位. 日ごと、全て等"
      t.date :target_date, comment: "実行対象日. output_unit が daily の場合に指定"
      t.bigint :data_count
      t.string :file_name
      t.bigint :file_size
      t.string :upload_to
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end

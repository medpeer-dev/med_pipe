# frozen_string_literal: true

class CreateMedPipePipelineGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :med_pipe_pipeline_groups do |t|
      t.integer :parallel_limit, null: false, default: 1, comment: "並列実行数"
      t.timestamps
    end

    add_reference :med_pipe_pipeline_plans, :pipeline_group, null: false
  end
end

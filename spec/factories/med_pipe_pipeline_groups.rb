# frozen_string_literal: true

FactoryBot.define do
  factory :med_pipe_pipeline_group, class: "MedPipe::PipelineGroup" do
    parallel_limit { 1 }
  end
end

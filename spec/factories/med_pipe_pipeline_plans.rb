# frozen_string_literal: true

FactoryBot.define do
  factory :med_pipe_pipeline_plan, class: "MedPipe::PipelinePlan" do
    name { "dummy" }
    output_unit { :all }
    status { :waiting }
    association :pipeline_group, factory: :med_pipe_pipeline_group
  end
end

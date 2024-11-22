# frozen_string_literal: true

class MedPipe::PipelineGroup < MedPipe::ApplicationRecord
  has_many :pipeline_plans, class_name: "MedPipe::PipelinePlan", dependent: :destroy
end

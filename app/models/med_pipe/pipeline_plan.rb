# frozen_string_literal: true

class MedPipe::PipelinePlan < MedPipe::ApplicationRecord
  belongs_to :pipeline_group, class_name: "MedPipe::PipelineGroup", optional: true

  scope :active, -> { where(status: %i[enqueued running]) }

  validates :name, presence: true
  validates :output_unit, presence: true
  validates :status, presence: true

  enum :status, {
    waiting: "waiting",
    enqueued: "enqueued",
    running: "running",
    finished: "finished",
    failed: "failed"
  }, prefix: true, default: :waiting

  enum :output_unit, {
    daily: "daily",
    all: "all"
  }, prefix: true
end

# frozen_string_literal: true

class MedPipe::PipelinePlan < MedPipe::ApplicationRecord
  belongs_to :pipeline_group, class_name: "MedPipe::PipelineGroup", optional: true

  scope :active, -> { where(status: %i[enqueued running]) }

  validates :name, presence: true
  validates :output_unit, presence: true
  validates :status, presence: true

  # TODO: Rails6記法のため、Rails8に上げる際に定義の仕方を変える
  # https://zenn.dev/kanazawa/articles/8bc1fcbba3ef1d#enum%E3%81%AE%E5%AE%9A%E7%BE%A9%E6%96%B9%E6%B3%95%E3%81%8C%E5%A4%89%E3%82%8F%E3%82%8B
  enum status: {
    waiting: "waiting",
    enqueued: "enqueued",
    running: "running",
    finished: "finished",
    failed: "failed"
  }, _prefix: true

  enum output_unit: {
    daily: "daily",
    all: "all"
  }, _prefix: true
end

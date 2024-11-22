# frozen_string_literal: true

# enqueued な pipeline plan を1つ取得 & 実行
class MedPipe::PipelinePlanConsumer
  # @param [Proc] pipeline_runner pipeline plan から pipeline を作成し実行する
  def initialize(pipeline_group_id:, pipeline_runner:)
    @pipeline_group_id = pipeline_group_id
    @pipeline_runner = pipeline_runner
  end

  # @return [PipelinePlan] 実行した pipeline plan。なければ nil
  def run
    pipeline_plan = fetch_and_run_pipeline_plan
    return nil if pipeline_plan.nil?

    @pipeline_runner.call(pipeline_plan)
    complete_pipeline_plan(pipeline_plan)
    pipeline_plan
  rescue StandardError => e
    error_pipeline_plan(pipeline_plan)
    raise e
  end

  private

  def fetch_and_run_pipeline_plan
    ApplicationRecord.transaction do
      target_pipeline_plan = MedPipe::PipelinePlan
                             .lock.where(status: :enqueued, pipeline_group_id: @pipeline_group_id)
                             .order(priority: :desc).first
      return if target_pipeline_plan.nil?

      target_pipeline_plan.update!(status: :running)
      target_pipeline_plan
    end
  end

  def complete_pipeline_plan(pipeline_plan)
    pipeline_plan.update!(status: :finished, finished_at: Time.current)
  end

  def error_pipeline_plan(pipeline_plan)
    pipeline_plan.update!(status: :failed)
  end
end

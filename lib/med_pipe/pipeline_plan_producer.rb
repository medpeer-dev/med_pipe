# frozen_string_literal: true

# prioryty が高いものから順に、並列数を踏まえて複数のPipelinePlanの状態をenqueuedに変更する
class MedPipe::PipelinePlanProducer
  # @param pipeline_group [MedPipe::PipelineGroup]
  def initialize(pipeline_group)
    @pipeline_group = pipeline_group
  end

  # @return [Array<MedPipe::PipelinePlan>] Enqueued pipeline plans. 未実行ならnilを返す
  def run
    return if @pipeline_group.parallel_limit <= 0

    @pipeline_group.with_lock do
      enqueue_count = @pipeline_group.parallel_limit - @pipeline_group.pipeline_plans.active.count
      enqueue(enqueue_count) if enqueue_count.positive?
    end
  end

  private

  def enqueue(size)
    target_pipeline_plans = fetch_target_pipeline_plans(size: size)
    return if target_pipeline_plans.empty?

    target_pipeline_plans.each do |pipline_plan|
      pipline_plan.update!(status: :enqueued)
    end
  end

  def fetch_target_pipeline_plans(size:)
    @pipeline_group.pipeline_plans.status_waiting.order(priority: :desc).limit(size)
  end
end

# frozen_string_literal: true

# PipelinePlanのEnqueueとRunを行うJob
# MEMO: このJobもMedPipeに含めて、設定だけ外から入れてもらうでもいいかもしれない
class SampleExecutePipelineJob < ApplicationJob
  queue_as :default

  def perform(pipeline_group_id, start = true, interval_sec = 30)
    pipeline_group = MedPipe::PipelineGroup.find(pipeline_group_id)
    consume(pipeline_group) unless start
    produce(pipeline_group, interval_sec)
  end

  private

  def consume(pipeline_group)
    consumer = MedPipe::PipelinePlanConsumer.new(pipeline_group: pipeline_group, pipeline_runner: SamplePipelineRunner.new)
    consumed_plan = consumer.run
    if consumed_plan.nil?
      raise "No enqueued pipeline plan"
    end
  end

  def produce(pipeline_group, interval_sec)
    enqueued_plans = MedPipe::PipelinePlanProducer.new(pipeline_group).run

    if enqueued_plans.blank?
      on_finish if pipeline_group.pipeline_plans.active.empty?
      return
    end

    enqueued_plans.each_with_index do |_, i|
      wait_sec = i * interval_sec
      self.class.set(wait: wait_sec).perform_later(pipeline_group.id, false, interval_sec)
    end
  end

  def on_finish
    # 終了通知処理をここに書く想定
  end
end

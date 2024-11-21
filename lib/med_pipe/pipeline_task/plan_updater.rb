# frozen_string_literal: true

class MedPipe::PipelineTask::PlanUpdater
  # @param save [Boolean] trueの場合、Planを保存する。finishにするために更新が走るためここで保存しないことをdefaultにしている
  def initialize(save: false)
    @save = save
  end

  # @param context [Hash]
  # @param input [Enumerable<Array<Object>>]
  # @yieldparam [Enumerable<Array<Object>>] inputをそのまま流す
  def call(context, input)
    update_plan(context)
    block_given? ? yield(input) : input
  end

  private

  def update_plan(context)
    return unless context[:plan]

    plan = context[:plan]
    plan.data_count = context[:data_count] if context[:data_count]
    plan.file_name = context[:file_name] if context[:file_name]
    plan.file_size = context[:file_size] if context[:file_size]
    plan.upload_to = context[:upload_to] if context[:upload_to]
    plan.save if @save
  end
end

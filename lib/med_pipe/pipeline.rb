# frozen_string_literal: true

# 直列に繋いだtaskを順番に実行するクラス
class MedPipe::Pipeline
  def initialize
    @tasks = []
  end

  # @param task [Object] def call(context, prev_result, &block) を実装したクラス
  def apply(task)
    @tasks << task
    self
  end

  # @param context [Hash] Stores data during pipeline execution
  def run(context = {}) = run_task_recursive(context)
  # 展開すると以下のようになる
  # @tasks[0].call(context, nil) do |prev_result|
  #   @tasks[1].call(context, prev_result) do |prev_result|
  #     @tasks[2].call(context, prev_result) do |prev_result|
  #       nil
  #     end
  #   end
  # end

  private

  def run_task_recursive(context, prev_result = nil, task_index = 0)
    return prev_result if task_index >= @tasks.size

    @tasks[task_index]&.call(context, prev_result) do |result|
      run_task_recursive(context, result, task_index + 1)
    end
  end
end

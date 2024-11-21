# frozen_string_literal: true

class MedPipe::PipelineTask::Counter
  def initialize
    @count = 0
  end

  # @param context [Hash]
  # @param input [Enumerable<Array<Object>>]
  # @yieldparam [Enumerable<Array<Object>>] inputをそのまま流す
  def call(context, input)
    yield input.map { |x| increment(context); x } # rubocop:disable Style/Semicolon
  end

  def increment(context)
    @count += 1
    context[:data_count] = @count
  end
end

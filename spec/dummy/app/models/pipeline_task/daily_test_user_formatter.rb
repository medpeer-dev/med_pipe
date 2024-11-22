# frozen_string_literal: true

class PipelineTask::DailyTestUserFormatter
  # @param [Enumerable<Array<Object>>] records
  # @yieldparam [Enumerable<Array<Object>>] 各レコードの出力したい値の配列
  def call(_context, records)
    yield records.map { |record| format_line(record) }
  end

  def format_line(record)
    [
      "ID#{record[0]}", # id
      record[1] # name
    ]
  end
end

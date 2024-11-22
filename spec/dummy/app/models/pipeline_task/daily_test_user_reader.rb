# frozen_string_literal: true

class PipelineTask::DailyTestUserReader
  BATCH_SIZE = 1000

  def initialize(target_date)
    @target_date = target_date
  end

  # BatchReader を使って大量のデータを分割して読み込むサンプル
  # find_each のように、batch_size単位でDBから取得し、1件ずつ流れる。
  # lazy を使うことで必要になるまでロードしない
  def call(_context, _)
    yield MedPipe::BatchReader.new(
      TestUser,
      scope: TestUser.where(created_at: @target_date.all_day),
      pluck_columns:,
      batch_size: BATCH_SIZE
    ).each.lazy
  end

  def pluck_columns
    %i[id name]
  end
end

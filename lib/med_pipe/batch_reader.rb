# frozen_string_literal: true

# 大量データを分割取得するためのクラス
# in_batches では scope が全クエリに含まれるが、本クラスではidの取得でのみ scope を使用する
class MedPipe::BatchReader
  def initialize(model_class, scope: nil, pluck_columns: [:id], batch_size: 1_000,
                 max_id_load_size: 100_000)
    @model_class = model_class
    @scope = scope || model_class.all
    @pluck_columns = pluck_columns
    @batch_size = batch_size
    @max_id_load_size = max_id_load_size
    @around_load_callback = nil
    validate_parameters
  end

  # EXAMPLE:
  #   MedPipe::BatchReader.new(User)
  #     .around_load { |&block| ApplicationRecord.connected_to(role: :reading, &block) }
  def around_load(&block)
    @around_load_callback = block
    self
  end

  # @yieldparam [Array] pluck結果を1件ずつ渡す
  def each(&block)
    return enum_for(:each) unless block

    each_ids = MedPipe::BatchIdFetcher.new(@scope, batch_size: @batch_size, max_load_size: @max_id_load_size).each
    loop do
      records = @around_load_callback&.call { batch_load(each_ids) } || batch_load(each_ids)
      records.each(&block)
    rescue StopIteration
      break
    end
  end

  private

  def validate_parameters
    raise ArgumentError, "model_class must be a subclass of ApplicationRecord" unless @model_class < ApplicationRecord
  end

  def batch_load(each_ids)
    # in_batches ではクエリキャッシュが無効になっているため、それに倣う
    @model_class.uncached do
      @model_class.where(id: each_ids.next).pluck(*@pluck_columns)
    end
  end
end

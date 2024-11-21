# frozen_string_literal: true

# idを最大max_load_size件ずつ分割取得するためのクラス
# 使い時:
# - 10万件以上のidを取得したい場合
# - 速度を改善するために in_batches を使いたくない場合
class MedPipe::BatchIdFetcher
  def initialize(relation, batch_size: 1_000, max_load_size: 100_000)
    @relation = relation
    @batch_size = batch_size
    @max_load_size = max_load_size
    validate_parameters
  end

  def each
    return enum_for(:each) unless block_given?

    last_id = 0
    cached_ids = []

    loop do
      loaded_ids = load_ids(last_id)
      break if loaded_ids.blank?

      last_id = loaded_ids.last
      cached_ids.concat(loaded_ids)
      yield(cached_ids.shift(@batch_size)) while cached_ids.size >= @batch_size

      if loaded_ids.size < @max_load_size
        yield(cached_ids) if cached_ids.present?
        break
      end
    end
  end

  private

  def validate_parameters
    raise ArgumentError, "batch_size must be greater than 0" if @batch_size <= 0
  end

  def load_ids(last_id)
    if last_id.zero?
      @relation.limit(@max_load_size).order(:id).ids
    else
      @relation.where("id > ?", last_id).order(:id).limit(@max_load_size).ids
    end
  end
end

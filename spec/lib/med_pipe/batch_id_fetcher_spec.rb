# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedPipe::BatchIdFetcher do
  let(:batch_size) { 2 }
  let(:max_result_size) { 5 }
  let(:relation) { TestUser.all }
  let(:fetcher) { described_class.new(relation, batch_size: batch_size, max_result_size: max_result_size) }

  describe "#initialize" do
    context "with invalid batch_size" do
      it "raises ArgumentError when batch_size is 0" do
        expect do
          described_class.new(relation, batch_size: 0)
        end.to raise_error(ArgumentError, "batch_size must be greater than 0")
      end

      it "raises ArgumentError when batch_size is negative" do
        expect do
          described_class.new(relation, batch_size: -1)
        end.to raise_error(ArgumentError, "batch_size must be greater than 0")
      end
    end
  end

  describe "#each" do
    context "when no block is given" do
      it "returns an Enumerator" do
        expect(fetcher.each).to be_an(Enumerator)
      end
    end

    context "when records exist" do
      before do
        # テストデータの作成
        7.times { |i| TestUser.create!(name: "User #{i}") }
      end

      it "yields arrays of ids with specified batch_size" do
        results = fetcher.each.to_a

        expect(results.length).to eq(4)
        # 最初の2つのバッチは batch_size(2) の長さ
        expect(results[0].length).to eq(batch_size)
        expect(results[1].length).to eq(batch_size)
        # 最後のバッチは残りのID
        expect(results.last.length).to eq(1)
        # 全てのIDが取得されていることを確認
        expect(results.flatten).to match_array(TestUser.all.ids)
      end

      context "with max_result_size smaller than total records" do
        let(:max_result_size) { 3 }

        before do
          allow(fetcher).to receive(:load_ids).and_call_original
        end

        it "fetches records in multiple batches" do
          results = fetcher.each.to_a

          # load_idsが3回呼ばれることを確認
          # 1回目: id 1-3
          # 2回目: id 4-6
          # 3回目: id 7
          expect(fetcher).to have_received(:load_ids).exactly(3).times

          # その他の検証
          expect(results.flatten.size).to eq(TestUser.count)
          expect(results.flatten).to match_array(TestUser.all.ids)
        end

        it "calls load_ids with correct last_id" do
          fetcher.each.to_a

          # 呼び出し時の引数を順番に検証
          expect(fetcher).to have_received(:load_ids).with(0).ordered
          expect(fetcher).to have_received(:load_ids).with(3).ordered
          expect(fetcher).to have_received(:load_ids).with(6).ordered
        end
      end
    end

    context "when no records exist" do
      it "yields nothing" do
        results = fetcher.each.to_a
        expect(results).to be_empty
      end
    end
  end
end

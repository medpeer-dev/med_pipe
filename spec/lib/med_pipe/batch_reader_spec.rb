# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedPipe::BatchReader do
  let(:model_class) { TestUser }
  let(:scope) { TestUser.where(created_at: Date.current.all_day) }
  let(:pluck_columns) { %i[id name] }
  let(:record_reader) { described_class.new(model_class, scope: scope, pluck_columns: pluck_columns) }

  describe "#each" do
    context "when no block is given" do
      it "returns an Enumerator" do
        expect(record_reader.each).to be_an(Enumerator)
      end
    end

    context "when records exist" do
      before do
        create(:test_user, name: "User yesterday", created_at: Date.yesterday)
        7.times { |i| create(:test_user, name: "User #{i}") }
        create(:test_user, name: "User tomorrow", created_at: Date.tomorrow)
      end

      it "pluckした結果を1件ずつ渡す" do
        results = record_reader.each.to_a

        expect(results.length).to eq(7)
        expect(results[0].length).to eq(2)
        expect(results[0][1]).to eq("User 0")
      end
    end
  end
end

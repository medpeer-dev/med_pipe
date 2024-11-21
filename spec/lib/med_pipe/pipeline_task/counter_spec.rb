# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedPipe::PipelineTask::Counter do
  let(:counter) { described_class.new }

  describe "#call" do
    it "increment data_count" do
      input = (1..1000).lazy
      dummy_block_return_value = "dummy_block_return_value"
      context = {}

      return_value = counter.call(context, input) do |yield_param|
        expect(yield_param).to be_a(Enumerator::Lazy)
        yield_param.force
        dummy_block_return_value
      end
      expect(return_value).to eq(dummy_block_return_value)
      expect(context[:data_count]).to eq(1000)
    end
  end
end

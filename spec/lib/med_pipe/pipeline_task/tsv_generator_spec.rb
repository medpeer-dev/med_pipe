# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedPipe::PipelineTask::TsvGenerater do
  describe "#call" do
    let(:tsv_generater) { described_class.new }

    let(:lines) do
      [
        [1, "", "", 0, "", 0],
        [2, "2023-02-01", "2023-03-01", 2, "2023-01-01", 100]
      ]
    end

    let(:expected_tsv) do
      <<~TSV
        1\t\t\t0\t\t0
        2\t2023-02-01\t2023-03-01\t2\t2023-01-01\t100
      TSV
    end

    it "tsvファイルを作成する" do
      tsv_generater.call({}, lines) do |temp_file|
        expect(temp_file.read).to eq(expected_tsv)
      end
    end
  end
end

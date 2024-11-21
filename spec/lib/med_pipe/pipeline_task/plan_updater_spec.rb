# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedPipe::PipelineTask::PlanUpdater do
  let(:updater) { described_class.new }

  describe "#call" do
    let(:pipeline_plan) { build(:med_pipe_pipeline_plan) }
    let(:context) do
      {
        plan: pipeline_plan,
        data_count: 1000,
        file_name: "example.txt",
        file_size: 1024,
        upload_to: "test_s3"
      }
    end

    it "updates the plan with context data" do
      input = "dummy_input"
      updater.call(context, input) do |yield_param|
        expect(yield_param).to eq(input)
      end
      expect(pipeline_plan).to have_attributes(
        data_count: 1000,
        file_name: "example.txt",
        file_size: 1024,
        upload_to: "test_s3"
      )
      expect(pipeline_plan).not_to be_persisted
    end

    context "save option is true" do
      let(:updater) { described_class.new(save: true) }

      it "set and save" do
        updater.call(context, "dummy_input")
        expect(pipeline_plan.reload.data_count).to eq(1000)
      end
    end
  end
end

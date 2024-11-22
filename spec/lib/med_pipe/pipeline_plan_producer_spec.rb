# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedPipe::PipelinePlanProducer do
  describe "#run" do
    let(:pipeline_group) { create(:med_pipe_pipeline_group, parallel_limit: parallel_limit) }
    let(:producer) { described_class.new(pipeline_group) }

    before do
      7.times do |i|
        create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :waiting, priority: i)
      end

      # 別グループのplan
      create(:med_pipe_pipeline_plan, priority: 100, status: :waiting)
      create(:med_pipe_pipeline_plan, priority: 100, status: :running)
    end

    context "parallel_limit is 0" do
      let(:parallel_limit) { 0 }

      it "returns nil" do
        expect(producer.run).to eq(nil)
      end
    end

    context "activeなplanがない場合" do
      let(:parallel_limit) { 3 }

      it "priority_limit 分だけenqueuedにする" do
        return_value = producer.run

        expect(return_value.length).to eq(3)
        expect(return_value[0].priority).to eq(6)
        expect(return_value[1].priority).to eq(5)
        expect(MedPipe::PipelinePlan.where(status: :enqueued).count).to eq(3)
      end
    end

    context "activeなplanが並列数以下の場合" do
      let(:parallel_limit) { 3 }

      before do
        create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :running)
      end

      it "(priority_limit - activeな数)分enqueuedにする" do
        return_value = producer.run
        expect(return_value.length).to eq(2)
        expect(return_value[0].priority).to eq(6)
        expect(MedPipe::PipelinePlan.where(status: :enqueued).count).to eq(2)
      end
    end

    context "activeなplanが並列数以上の場合" do
      let(:parallel_limit) { 3 }

      before do
        create_list(:med_pipe_pipeline_plan, 2, pipeline_group: pipeline_group, status: :enqueued)
        create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :running)
      end

      it "何もしない" do
        return_value = producer.run
        expect(return_value).to eq(nil)
        expect(MedPipe::PipelinePlan.where(status: :enqueued).count).to eq(2)
      end
    end
  end
end

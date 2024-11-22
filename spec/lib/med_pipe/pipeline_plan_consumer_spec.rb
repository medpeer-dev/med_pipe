# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedPipe::PipelinePlanConsumer do
  describe "#run" do
    let(:pipeline_group) { create(:med_pipe_pipeline_group) }
    let(:pipeline_runner) { instance_double(MedPipe::PipelineRunnerBase) }
    let(:consumer) { described_class.new(pipeline_group_id: pipeline_group.id, pipeline_runner: pipeline_runner) }

    before do
      create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :waiting)

      # 別グループのplan
      create(:med_pipe_pipeline_plan, priority: 100, status: :waiting)
      create(:med_pipe_pipeline_plan, priority: 100, status: :running)
    end

    context "異常系 enqueued なPlanがないとき" do
      it "returns nil" do
        expect(consumer.run).to eq(nil)
      end
    end

    context "enqueued なPlanが1つあるとき" do
      let!(:target_plan) { create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :enqueued) }

      it "Planが実行される" do
        expect(pipeline_runner).to receive(:call).once
        plan = consumer.run
        expect(plan.status).to eq("finished")
        expect(plan.id).to eq(target_plan.id)
      end
    end

    context "enqueued なPlanが複数あるとき" do
      before do
        create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :enqueued, priority: 1)
        create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :enqueued, priority: 2)
      end

      it "priorityの高いPlanが実行される" do
        expect(pipeline_runner).to receive(:call).once
        plan = consumer.run
        expect(plan.priority).to eq(2)
        expect(MedPipe::PipelinePlan.where(status: :enqueued).count).to eq(1)
      end
    end

    context "PipelineRunnerがエラーを投げたとき" do
      let!(:target_plan) { create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :enqueued) }

      before do
        allow(pipeline_runner).to receive(:call).and_raise("error")
      end

      it "Planがfailedになる" do
        expect { consumer.run }.to raise_error("error")
        expect(target_plan.reload.status).to eq("failed")
      end
    end
  end
end

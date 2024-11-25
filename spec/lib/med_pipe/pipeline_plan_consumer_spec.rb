# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedPipe::PipelinePlanConsumer do
  describe "#run" do
    let(:pipeline_group) { create(:med_pipe_pipeline_group) }
    let(:pipeline_runner) { instance_double(MedPipe::PipelineRunnerBase) }
    let(:consumer) { described_class.new(pipeline_group: pipeline_group, pipeline_runner: pipeline_runner) }

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

  describe "結合テスト" do
    let(:pipeline_group) { create(:med_pipe_pipeline_group) }
    let(:pipeline_runner) { SamplePipelineRunner.new } # SamplePipelineRunnerで作るPipelineが正常に動作するかをテストする
    let(:consumer) { described_class.new(pipeline_group: pipeline_group, pipeline_runner: pipeline_runner) }
    let(:created_time) { Time.zone.parse("2024-11-11 12:00:00") }
    let!(:plan) do
      create(:med_pipe_pipeline_plan,
             name: name,
             pipeline_group: pipeline_group,
             status: :enqueued,
             target_date: created_time.to_date)
    end

    context "daily_test_user" do
      let(:name) { "daily_test_user" }

      before do
        create(:test_user, name: "User yesterday", created_at: created_time.yesterday)
        7.times { |i| create(:test_user, name: "User #{i}", created_at: created_time) }
        create(:test_user, name: "User tomorrow", created_at: created_time.tomorrow)
      end

      it "Pipelineが正常に動作し、Planに結果が保存される" do
        expect { consumer.run }.to change { plan.reload.status }.from("enqueued").to("finished")
        expect(plan).to have_attributes(
          data_count: 7,
          file_name: "daily_test_user_20241111.tsv"
        )
      end
    end
  end
end

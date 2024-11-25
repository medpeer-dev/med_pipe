# frozen_string_literal: true

require "rails_helper"

RSpec.describe SampleExecutePipelineJob, type: :job do
  describe "#perform" do
    let(:pipeline_group) { create(:med_pipe_pipeline_group) }
    let(:consumer) { instance_double(MedPipe::PipelinePlanConsumer) }
    let(:producer) { instance_double(MedPipe::PipelinePlanProducer) }
    let(:job) { described_class.new }

    before do
      allow(MedPipe::PipelinePlanConsumer).to receive(:new).and_return(consumer)
      allow(MedPipe::PipelinePlanProducer).to receive(:new).and_return(producer)
    end

    context "start = true のとき" do
      let!(:pipeline_plans) do
        [
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group),
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group),
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group)
        ]
      end

      it "consumeは呼ばれず、produceが呼ばれる" do
        expect(consumer).not_to receive(:run)
        waiting_plans = pipeline_plans.select(&:status_waiting?)
        expect(producer).to receive(:run).and_return(waiting_plans).once
        expect do
          job.perform(pipeline_group.id, true)
        end.to have_enqueued_job(SampleExecutePipelineJob).exactly(3).times
      end
    end

    context "start = false のとき" do
      let!(:pipeline_plans) do
        [
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :finished),
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :finished),
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group)
        ]
      end

      it "consume & produce" do
        finished_plan = pipeline_plans.select(&:status_finished?).last
        expect(consumer).to receive(:run).and_return(finished_plan)
        waiting_plans = pipeline_plans.select(&:status_waiting?)
        expect(producer).to receive(:run).and_return(waiting_plans).once
        expect do
          job.perform(pipeline_group.id, false)
        end.to have_enqueued_job(SampleExecutePipelineJob).exactly(1).times
      end
    end

    context "enqueued_plans が nil かつ他タスクが active なとき" do
      let!(:pipeline_plans) do
        [
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :finished),
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :finished),
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :running)
        ]
      end

      before do
        finished_plan = pipeline_plans.select(&:status_finished?).last
        allow(consumer).to receive(:run).and_return(finished_plan)
        waiting_plans = pipeline_plans.select(&:status_waiting?)
        allow(producer).to receive(:run).and_return(waiting_plans)
      end

      it "on_finishが呼ばれない" do
        expect(job).not_to receive(:on_finish)
        expect do
          job.perform(pipeline_group.id, false)
        end.not_to have_enqueued_job(SampleExecutePipelineJob)
      end
    end

    context "enqueued_plans が nil かつ他タスクが active ではないとき" do
      let!(:pipeline_plans) do
        [
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :finished),
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :finished),
          create(:med_pipe_pipeline_plan, pipeline_group: pipeline_group, status: :finished)
        ]
      end

      before do
        finished_plan = pipeline_plans.select(&:status_finished?).last
        allow(consumer).to receive(:run).and_return(finished_plan)
        allow(producer).to receive(:run).and_return(nil)
      end

      it "on_finishが呼ばれる" do
        expect(job).to receive(:on_finish).once
        expect do
          job.perform(pipeline_group.id, false)
        end.not_to have_enqueued_job(SampleExecutePipelineJob)
      end
    end

    context "異常系 enqueued なPlanがないとき" do
      before do
        allow(consumer).to receive(:run).and_return(nil)
      end

      it "raises error" do
        expect { job.perform(pipeline_group.id, false) }.to raise_error("No enqueued pipeline plan")
      end
    end
  end
end

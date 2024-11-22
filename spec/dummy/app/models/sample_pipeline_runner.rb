# frozen_string_literal: true

class SamplePipelineRunner < MedPipe::PipelineRunnerBase
  def build_pipeline(pipeline_plan)
    case pipeline_plan.name
    when "daily_test_user"
      MedPipe::Pipeline.new
                       .apply(PipelineTask::DailyTestUserReader.new(pipeline_plan.target_date))
                       .apply(PipelineTask::DailyTestUserFormatter.new)
                       .apply(MedPipe::PipelineTask::Counter.new)
                       .apply(MedPipe::PipelineTask::TsvGenerater.new)
                       .apply(PipelineTask::DummyUploader.new(
                                upload_file_name: daily_file_name("daily_test_user", pipeline_plan.target_date)
                              ))
                       .apply(MedPipe::PipelineTask::PlanUpdater.new)
    else
      raise ArgumentError, "unknown pipeline name: #{name}"
    end
  end

  private

  def daily_file_name(prefix, date)
    "#{prefix}_#{date.strftime('%Y%m%d')}.tsv"
  end
end

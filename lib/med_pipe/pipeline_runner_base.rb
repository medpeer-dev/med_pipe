# frozen_string_literal: true

# PipelinePlanConsumerに渡すPipelineRunnerの作成を補助するクラス
# call(pipeline_plan)さえ実装していれば良いため、必ずしも本クラスを使う必要はありません。
class MedPipe::PipelineRunnerBase
  # PipelinePlanConsumerから呼び出されるメソッド
  def call(pipeline_plan)
    pipeline = build_pipeline(pipeline_plan)
    context = { plan: pipeline_plan }
    pipeline.run(context)
  end

  def build_pipeline(pipeline_plan)
    raise NotImplementedError("#{pipeline_plan.name}に対応するPipelineを作成する処理をサブクラスで実装してください")
  end
end

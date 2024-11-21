# frozen_string_literal: true

require "rails_helper"

RSpec.describe MedPipe::Pipeline do
  describe "#run" do
    let(:pipeline) { described_class.new }

    let(:task_class) do
      Class.new do
        def initialize(num)
          @num = num
        end

        def call(_context, prev_result)
          if prev_result.nil?
            yield [@num]
          else
            yield prev_result + [@num]
          end
        end
      end
    end

    context "タスクを中断しない場合" do
      before do
        index = 0
        3.times do
          index += 1
          pipeline.apply(task_class.new(index))
        end
      end

      it "全て順番に実行する" do
        expect(pipeline.run).to eq([1, 2, 3])
      end
    end

    context "タスクを中断する場合" do
      let(:stop_task_class) do
        Class.new do
          def call(_context, prev_result)
            prev_result
          end
        end
      end

      it "中断した結果を返す" do
        index = 0
        2.times do
          index += 1
          pipeline.apply(task_class.new(index))
        end

        pipeline.apply(stop_task_class.new)

        3.times do
          index += 1
          pipeline.apply(task_class.new(index))
        end

        expect(pipeline.run).to eq([1, 2])
      end
    end
  end
end

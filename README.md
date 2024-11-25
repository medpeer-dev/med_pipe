# MedPipe <sup>BETA</sup>
100万 ~ 数10億程度のデータを処理するための仕組みを提供する Rails エンジンです。

## Concept
### MedPipe::Pipeline
apply で後述する PipelineTask を登録し、run で順番に実行します。

### MedPipe::PipelineTask
Pipeline に登録する処理の単位です。  
DB からの読み込みや、S3 へのアップロード等やることを分割してタスク化します。  
大量データを扱う際には Enumerable::Lazy を使うことで分割して処理をすることができます。  
call を実装する必要があります

```.rb
@param context [Hash] Stores data during pipeline execution
@param prev_result [Object] The result of the previous task
def call(context, prev_result)
  yield 次のTaskに渡すデータ
end
```

### MedPipe::PipelinePlan
Pipeline の状態、オプション、結果を保存するためのモデルです。  
Task で使うためのオプションを渡す方法は PipelinePlan から取得するか、contextで伝搬するかの二択です。

### MedPipe::PipelineGroup
一つのジョブで実行する Plan をまとめるためのモデルです。  
実行中に parallel_limit を 0 にすることで中断することができます。

## Usage

1. Reader, Uploader 等の PipelineTask を作成 [Samples](https://github.com/medpeer-dev/med_pipe/tree/main/spec/dummy/app/models/pipeline_task)
2. PipelineRunner を作成 [Sample](https://github.com/medpeer-dev/med_pipe/blob/main/spec/dummy/app/models/sample_pipeline_runner.rb)
3. Pipeline を並列実行するためのジョブを作成 [Sample](https://github.com/medpeer-dev/med_pipe/blob/main/spec/dummy/app/jobs/sample_execute_pipeline_job.rb)
4. PipelinePlan を登録するコードを記述
5. 実行

## Installation
Add this line to your application's Gemfile:

```ruby
gem "med_pipe"
```

### migrationファイルの追加

```shell
$ rails med_pipe:install:migrations
```

## Contributing
Bug reports and pull requests are welcome.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

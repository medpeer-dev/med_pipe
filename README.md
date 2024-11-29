# MedPipe
A Rails engine that provides mechanisms for processing datasets ranging from 1 million to several billion records.

## Concept

![MedPipeConcept](https://github.com/user-attachments/assets/69ef986b-33cc-478c-830f-78d24ff6c9f4)

### MedPipe::Pipeline
Register PipelineTask through 'apply' method and execute them sequentially using 'run'.

### MedPipe::PipelineTask
This is the basic unit of processing registered in the pipeline.  
Tasks are divided into specific operations such as reading from DB or uploading to S3.  
When handling large datasets, Enumerable::Lazy can be used to process data in chunks.  
You need to implement the 'call' method:

```ruby
@param context [Hash] Stores data during pipeline execution
@param prev_result [Object] The result of the previous task
def call(context, prev_result)
  yield "data_to_pass_to_next_task"
end
```

### MedPipe::PipelinePlan
A model for storing pipeline state, options, and results.  
There are two ways to pass options for tasks: either retrieve from PipelinePlan or propagate through context.

### MedPipe::PipelineGroup
A model for grouping plans.  
Execution can be interrupted by setting parallel_limit to 0 during runtime.

## Usage

1. Create PipelineTask such as Reader, Uploader, etc. [Samples](https://github.com/medpeer-dev/med_pipe/tree/main/spec/dummy/app/models/pipeline_task)
2. Create PipelineRunner [Sample](https://github.com/medpeer-dev/med_pipe/blob/main/spec/dummy/app/models/sample_pipeline_runner.rb)
3. Create a job for parallel Pipeline execution [Sample](https://github.com/medpeer-dev/med_pipe/blob/main/spec/dummy/app/jobs/sample_execute_pipeline_job.rb)
4. Write code to register PipelinePlan
5. Execute like this:

```ruby
# add plan
pipeline_group = MedPipe::PipelineGroup.create!(parallel_limit: 10)
date_range = Date.new(2024, 6, 1)..Date.new(2024, 6, 30)
date_range.each do |date|
  pipeline_group.pipeline_plans.status_waiting.create!(name: 'point_events', output_unit: :daily, target_date: date)
end

# execute
ExecutePipelineJob.perform_later(pipeline_group.id)
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "med_pipe"
```

### Adding migration files

```shell
$ rails med_pipe:install:migrations
```

### Test

Add this line to your test.rb to use factories in med_pipe

```test.rb
config.factory_bot.definition_file_paths << MedPipe::Engine.root.join('spec/factories')
```

## Contributing
Bug reports and pull requests are welcome.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

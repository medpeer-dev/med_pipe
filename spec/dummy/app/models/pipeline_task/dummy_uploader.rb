
# frozen_string_literal: true

class PipelineTask::DummyUploader
  def initialize(upload_file_name:)
    @upload_file_name = upload_file_name
  end

  def call(context, file)
    # uploadする処理をここに書く想定

    context[:file_name] = @upload_file_name
    context[:file_size] = file.size
    context[:upload_to] = "dummy_upload_to"

    yield file
  end
end

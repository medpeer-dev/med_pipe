# frozen_string_literal: true

require "csv"

class MedPipe::PipelineTask::TsvGenerater
  TSV_OPTION = { col_sep: "\t" }.freeze

  # @param lines [Enumerable<Array<Object>>] to_s可能なオブジェクトの配列のEnumerable
  # @yieldparam [File] 生成したtsvファイル
  def call(_context, lines)
    Tempfile.create do |file|
      lines.each do |line|
        # nil に置き換えることで""という文字列が出力されてしまうのを回避
        normalized_line = line.map { |v| v == "" ? nil : v }
        tsv_line = CSV.generate_line(normalized_line, **TSV_OPTION)
        file.puts(tsv_line)
      end
      file.rewind

      yield(file)
    end
  end
end

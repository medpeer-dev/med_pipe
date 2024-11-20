# frozen_string_literal: true

class MedPipe::Engine < Rails::Engine
  # migrationファイルの生成コマンドを med_pipe_engine:install:migrations から med_pipe:install:migrations に変更
  # https://edgeapi.rubyonrails.org/classes/Rails/Engine.html#class-Rails::Engine-label-Engine+name
  engine_name "med_pipe"
end

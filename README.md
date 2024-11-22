# MedPipe <sup>BETA</sup>
100万 ~ 数10億程度のデータを処理するための仕組みを提供する Rails エンジンです。

## Concept
TODO 書く

- pipeline
- pipeline_task
- pipeline_plan
- pipeline_group

## Usage
TODO 書く

1. pipeline_runner の作成
2. ジョブの作成
3. pipeline_plan, groupの登録
4. 実行コマンドの作成

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

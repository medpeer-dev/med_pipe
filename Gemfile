# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

eval_gemfile "Gemfile.common"

gem "puma"

gem "rubocop", require: false
gem "rubocop-performance", require: false
gem "rubocop-rails", require: false
gem "rubocop-rspec", require: false

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

group :test do
  gem "rspec-rails", "~> 7.1.0"
end

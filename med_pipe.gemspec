# frozen_string_literal: true

require_relative "lib/med_pipe/version"

Gem::Specification.new do |spec|
  spec.name        = "med_pipe"
  spec.version     = MedPipe::VERSION
  spec.authors     = ["mpg-taichi-sato"]
  spec.homepage    = "https://github.com/medpeer-dev/med_pipe"
  spec.summary     = "Provides a system for processing data ranging from 1 million to several billion records"
  spec.description = "Provides a system for processing data ranging from 1 million to several billion records"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/medpeer-dev/med_pipe"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "spec/factories/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.2.0"
  spec.metadata["rubygems_mfa_required"] = "true"
end

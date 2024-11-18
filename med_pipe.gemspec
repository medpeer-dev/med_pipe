# frozen_string_literal: true

require_relative "lib/med_pipe/version"

Gem::Specification.new do |spec|
  spec.name        = "med_pipe"
  spec.version     = MedPipe::VERSION
  spec.authors     = ["mpg-taichi-sato"]
  spec.email       = ["taichi.sato@medpeer.co.jp"]
  spec.homepage    = "https://www.google.co.jp/"
  spec.summary     = "Summary of MedPipe."
  # spec.description = "TODO: Description of MedPipe."
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  # Rails 8にあげるためにはenumの書き方を変える必要がある
  spec.add_dependency "rails", ">= 6.1.7", "< 8.0"
  spec.metadata["rubygems_mfa_required"] = "true"
end

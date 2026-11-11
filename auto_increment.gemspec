# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "auto_increment/version"

Gem::Specification.new do |s|
  s.name = "auto_increment"
  s.version = AutoIncrement::VERSION.dup
  s.licenses = "MIT"
  s.platform = Gem::Platform::RUBY
  s.authors = ["Felipe Diesel"]
  s.email = ["felipediesel@gmail.com"]
  s.homepage = "https://github.com/felipediesel/auto_increment"
  s.summary = "Auto increment a string or integer column"
  s.description = "Automatically generates sequential values for string or integer Active Record columns."
  s.metadata["source_code_uri"] = "https://github.com/felipediesel/auto_increment"

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", ">= 7.1"
  s.add_dependency "activesupport", ">= 7.1"

  s.metadata["rubygems_mfa_required"] = "true"
end

# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "auto_increment/version"

Gem::Specification.new do |s|
  s.name        = "auto_increment"
  s.version     = AutoIncrement::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Felipe Diesel"]
  s.email       = ["felipediesel@gmail.com"]
  s.homepage    = "http://felipediesel.com"
  s.summary     = %q{Auto increment a string or integer field}
  s.description = %q{Automaticaly increments a string or integer field in ActiveRecord.}

  s.rubyforge_project = "auto_increment"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

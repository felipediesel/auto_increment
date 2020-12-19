# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'auto_increment/version'

Gem::Specification.new do |s|
  s.name        = 'auto_increment'
  s.version     = AutoIncrement::VERSION.dup
  s.licenses    = 'MIT'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Felipe Diesel']
  s.email       = ['diesel@hey.com']
  s.homepage    = 'http://github.com/felipediesel/auto_increment'
  s.summary     = 'Auto increment a string or integer field'
  s.description = 'Automaticaly increments a string or integer field ' \
                  'in ActiveRecord.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'activerecord', '>= 4.0'
  s.add_dependency 'activesupport', '>= 4.0'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-nc'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'appraisal'

  s.add_development_dependency 'sqlite3', '>= 1.3.13'
end

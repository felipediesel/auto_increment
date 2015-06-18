# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'auto_increment/version'

Gem::Specification.new do |s|
  s.name        = 'auto_increment'
  s.version     = AutoIncrement::VERSION.dup
  s.licenses    = 'MIT'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Felipe Diesel']
  s.email       = ['felipediesel@gmail.com']
  s.homepage    = 'http://github.com/felipediesel/auto_increment'
  s.summary     = 'Auto increment a string or integer field'
  s.description = 'Automaticaly increments a string or integer field ' \
                  'in ActiveRecord.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'activerecord', '~> 4.0'
  s.add_dependency 'activesupport', '~> 4.0'

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake', '~> 0'

  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'rspec-nc', '~> 0.2'
  s.add_development_dependency 'guard', '~> 2.12'
  s.add_development_dependency 'guard-rspec', '~> 4.5'
  s.add_development_dependency 'fuubar', '~> 2'
  s.add_development_dependency 'coveralls', '~> 0'
  s.add_development_dependency 'database_cleaner', '~> 1.4'

  s.add_development_dependency 'sqlite3', '~> 1.3'
end

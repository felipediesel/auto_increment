require 'bundler'
Bundler::GemHelper.install_tasks


require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Run Devise unit tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

require 'coveralls'
Coveralls.wear!

require 'pry'
require 'auto_increment'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

require 'support/active_record'

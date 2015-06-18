require 'coveralls'
Coveralls.wear!

require 'pry'
require 'auto_increment'
require 'database_cleaner'

ActiveRecord::Base.establish_connection adapter: 'sqlite3',
                                        database: 'spec/db/sync.db',
                                        timeout: 5000

# require 'support/active_record'
require 'support/database_cleaner'

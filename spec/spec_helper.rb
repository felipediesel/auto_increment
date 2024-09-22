# frozen_string_literal: true

require "pry"
require "auto_increment"
require "database_cleaner"

db_path = "spec/db/sync.db"

File.delete(db_path) if File.exist?(db_path)

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: db_path,
  timeout: 5000
)

require "support/active_record"
require "support/database_cleaner"

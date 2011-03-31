# encoding: utf-8

ENV["RAILS_ENV"] = "test"
require File.expand_path('../app/config/environment', __FILE__)
require 'rails/test_help'

require File.expand_path('../../lib/auto_increment', __FILE__)


config = YAML.load_file(File.dirname(__FILE__) + '/database.yml')
ActiveRecord::Base.establish_connection(config['test'])

ActiveRecord::Base.connection.create_table :accounts do |t|
  t.string :name
  t.date :code
end

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.integer :account_id
  t.string :letter_code
end


class Account < ActiveRecord::Base
  auto_increment

  has_many :users
end

class User < ActiveRecord::Base
  auto_increment :column => :letter_code, :scope => :account_id, :initial => 'A', :force => true

  belongs_to :account
end

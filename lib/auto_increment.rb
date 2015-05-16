require 'date'
require 'i18n'
require 'active_record'
require 'active_support'
require 'active_support/time_with_zone'
require 'auto_increment/version'

# +AutoIncrement+
module AutoIncrement
  autoload :Incrementor, 'auto_increment/incrementor'
  autoload :ActiveRecord, 'auto_increment/active_record'
end

ActiveRecord::Base.send :include, AutoIncrement::ActiveRecord

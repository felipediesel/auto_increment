module AutoIncrement
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def auto_increment(options = {})
        before_create Incrementor.new(options)
      end
    end
  end
end

# Extend ActiveRecord's functionality
ActiveRecord::Base.send :extend, AutoIncrement

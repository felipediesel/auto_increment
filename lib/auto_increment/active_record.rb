# +AutoIncrement+
module AutoIncrement
  # +AutoIncrement::ActiveRecord+
  module ActiveRecord
    extend ActiveSupport::Concern
    # +AutoIncrement::ActiveRecord::ClassMethods+
    module ClassMethods
      def auto_increment(column = nil, options = {})
        before_save Incrementor.new(column, options)
      end
    end
  end
end

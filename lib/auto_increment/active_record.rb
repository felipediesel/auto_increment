# +AutoIncrement+
module AutoIncrement
  # +AutoIncrement::ActiveRecord+
  module ActiveRecord
    extend ActiveSupport::Concern
    # +AutoIncrement::ActiveRecord::ClassMethods+
    module ClassMethods
      def auto_increment(options = {})
        before_create Incrementor.new(options)
      end
    end
  end
end

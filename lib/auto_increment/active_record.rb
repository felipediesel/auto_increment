# +AutoIncrement+
module AutoIncrement
  # +AutoIncrement::ActiveRecord+
  module ActiveRecord
    extend ActiveSupport::Concern
    # +AutoIncrement::ActiveRecord::ClassMethods+
    module ClassMethods
      def auto_increment(column = nil, options = {})
        options.reverse_merge! before: :create

        callback = "before_#{options[:before]}"

        send callback, Incrementor.new(column, options)
      end
    end
  end
end

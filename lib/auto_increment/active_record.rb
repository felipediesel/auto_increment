# frozen_string_literal: true

# +AutoIncrement+
module AutoIncrement
  # +AutoIncrement::ActiveRecord+
  module ActiveRecord
    extend ActiveSupport::Concern
    # +AutoIncrement::ActiveRecord::ClassMethods+
    module ClassMethods
      def auto_increment(column = nil, **options)
        send("before_#{options.fetch(:before, :create)}") do |record|
          Incrementor.new(record, column, **options).run
        end
      end
    end
  end
end

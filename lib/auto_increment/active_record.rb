# frozen_string_literal: true

# +AutoIncrement+
module AutoIncrement
  # +AutoIncrement::ActiveRecord+
  module ActiveRecord
    extend ActiveSupport::Concern

    # +AutoIncrement::ActiveRecord::ClassMethods+
    module ClassMethods
      def auto_increment(column = nil, **options)
        column ||= options.fetch(:column, :code)
        initial = options.fetch(:initial, 1)
        col = columns_hash[column.to_s]
        if col
          col_type = col.type
          if (col_type == :integer && !initial.is_a?(Integer)) ||
              (col_type.in?(%i[string text]) && !initial.is_a?(String))
            warn(
              "[DEPRECATION] The initial value type (#{initial.class}) does not match " \
              "the column type (#{col_type}) for column '#{column}' on #{name}. " \
              "This behavior is deprecated and will raise an error in the future."
            )
          end
        end

        send("before_#{options.fetch(:before, :create)}") do |record|
          Incrementor.new(record, column, **options).run
        end
      end
    end
  end
end

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

        auto_increment_deprecate_type_mismatch(column, options[:initial]) if options.key?(:initial)

        send("before_#{options.fetch(:before, :create)}") do |record|
          Incrementor.new(record, column, **options).run
        end
      end

      private

      def auto_increment_deprecate_type_mismatch(column, initial)
        col = columns_hash[column.to_s]
        return unless col

        col_type = col.type
        return if col_type == :integer && initial.is_a?(Integer)
        return if col_type.in?(%i[string text]) && initial.is_a?(String)

        warn(
          "[DEPRECATION] The initial value type (#{initial.class}) does not match " \
          "the column type (#{col_type}) for column '#{column}' on #{name}. " \
          "This behavior is deprecated and will raise an error in the future."
        )
      end
    end
  end
end

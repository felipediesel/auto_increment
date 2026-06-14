# frozen_string_literal: true

# +AutoIncrement+
module AutoIncrement
  # +AutoIncrement::Incrementor+
  class Incrementor
    def initialize(record, column = nil, **options)
      @record = record
      @column = column || options.fetch(:column, :code)
      @initial = resolve_initial(options)
      @force = options.fetch(:force, false)
      @scope = Array.wrap(options[:scope]).compact
      @model_scope = Array.wrap(options[:model_scope]).compact
      @lock = options.fetch(:lock, false)
    end

    def run
      write if can_write?
    end

    private

    def can_write?
      @record.send(@column).blank? || @force
    end

    def write
      @record.send :write_attribute, @column, increment
    end

    def maximum_query
      query = build_scopes(build_model_scope(@record.class))
      query = query.lock if lock?

      query
    end

    def build_scopes(query)
      @scope.each do |scope|
        query = query.where(scope => @record.send(scope)) if @record.respond_to?(scope)
      end

      query
    end

    def build_model_scope(query)
      @model_scope.each do |scope|
        query = query.send(scope)
      end

      query
    end

    def maximum
      query = maximum_query

      if column_string?
        quoted_column = @record.class.connection.quote_column_name(@column)
        query.select("#{quoted_column} max")
          .order(Arel.sql("LENGTH(#{quoted_column}) DESC, #{quoted_column} DESC"))
          .first.try :max
      else
        query.maximum @column
      end
    end

    def lock?
      @lock == true
    end

    def increment
      max = maximum

      max.blank? ? @initial : max.next
    end

    def resolve_initial(options)
      return options[:initial] if options.key?(:initial)

      column_string? ? "1" : 1
    end

    def column_string?
      col = @record.class.columns_hash[@column.to_s]
      col&.type&.in?(%i[string text])
    end
  end
end

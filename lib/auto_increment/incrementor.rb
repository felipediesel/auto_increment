# frozen_string_literal: true

# +AutoIncrement+
module AutoIncrement
  # +AutoIncrement::Incrementor+
  class Incrementor
    def initialize(record, column = nil, **options)
      @record = record
      @column = column || options.fetch(:column, :code)
      @initial = options.fetch(:initial, 1)
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
      query = build_scopes(build_model_scope(@record.class))
      query.lock if lock?

      if string?
        query.select("#{@column} max")
             .order(Arel.sql("LENGTH(#{@column}) DESC, #{@column} DESC"))
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

    def string?
      @initial.instance_of?(String)
    end
  end
end

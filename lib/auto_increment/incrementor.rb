# +AutoIncrement+
module AutoIncrement
  # +AutoIncrement::Incrementor+
  class Incrementor
    def initialize(column = nil, options = {})
      if column.is_a? Hash
        options = column
        column = nil
      end

      @column = column || options[:column] || :code
      @options = options.reverse_merge initial: 1, force: false
      @options[:scope] = [@options[:scope]] unless @options[:scope].is_a? Array
      @options[:model_scope] = [@options[:model_scope]] unless @options[:model_scope].is_a? Array
    end

    def before_create(record)
      @record = record
      write if can_write?
    end

    alias before_validation before_create
    alias before_save before_create

    private

    def can_write?
      @record.send(@column).blank? || @options[:force]
    end

    def write
      @record.send :write_attribute, @column, increment
    end

    def increment
      max = maximum

      max.blank? ? @options[:initial] : max.next
    end

    def maximum
      if @options[:scope_by_related_model]
        records = records_by_related_model
      else
        records = build_scopes(build_model_scope(@record.class))
      end

      records.lock if lock?

      if initial_class_string?
        records.select("#{@column} max")
        .order(Arel.sql("LENGTH(#{@column}) DESC, #{@column} DESC"))
        .first.try :max
      else
        records.maximum @column
      end
    end

    def build_scopes(query)
      @options[:scope].each do |scope|
        if scope.present? && @record.respond_to?(scope)
          query = query.where(scope => @record.send(scope))
        end
      end

      query
    end

    def build_model_scope(query)
      @options[:model_scope].reject(&:nil?).each do |scope|
        query = query.send(scope)
      end

      query
    end

    def records_by_related_model
      related_model = @record.send @options[:scope_by_related_model]
      related_model.send @record.class.name.downcase.pluralize
    end

    def lock?
      @options[:lock] == true
    end

    def initial_class_string?
      @options[:initial].class == String
    end
  end
end

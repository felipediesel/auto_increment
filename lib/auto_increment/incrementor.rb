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
      @options = options.reverse_merge scope: nil, initial: 1, force: false
      @options[:scope] = [@options[:scope]] unless @options[:scope].is_a? Array
      @options[:model_scopes] = [@options[:model_scopes]] unless @options[:model_scopes].is_a? Array
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

    def build_scopes(query)
      @options[:scope].each do |scope|
        if scope.present? && @record.respond_to?(scope)
          query = query.where(scope => @record.send(scope))
        end
      end

      query
    end

    def build_model_scopes(query)
      @options[:model_scopes].reject(&:nil?).each do |scope|
        query = query.send(scope)
      end

      query
    end

    def maximum
      query = build_scopes(build_model_scopes(@record.class))
      query.lock if lock?

      if string?
        query.select("#{@column} max")
             .order("LENGTH(#{@column}) DESC, #{@column} DESC")
             .first.try :max
      else
        query.maximum @column
      end
    end

    def lock?
      @options[:lock] == true
    end

    def increment
      max = maximum

      max.blank? ? @options[:initial] : max.next
    end

    def string?
      @options[:initial].class == String
    end
  end
end

# +AutoIncrement+
module AutoIncrement
  # +AutoIncrement::Incrementor+
  class Incrementor
    def initialize(options = {})
      @options = options.reverse_merge column: :code,
                                       scope: nil,
                                       initial: 1,
                                       force: false
      @options[:scope] = [@options[:scope]] unless @options[:scope].is_a? Array
    end

    def before_create(record)
      @record = record
      write if can_write?
    end

    private

    def can_write?
      @record.send(@options[:column]).blank? || @options[:force]
    end

    def write
      @record.send :write_attribute, @options[:column], increment
    end

    def build_scopes(query)
      @options[:scope].each do |scope|
        if scope.present? && @record.respond_to?(scope)
          query = query.where(scope => @record.send(scope))
        end
      end

      query
    end

    def maximum
      query = build_scopes @record.class

      if string?
        query.lock.select("#{@options[:column]} max")
          .order("LENGTH(#{@options[:column]}) DESC, #{@options[:column]} DESC")
          .first.try :max
      else
        query.lock.maximum @options[:column]
      end
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

require 'active_record'

module AutoIncrement
  def auto_increment(options = {})
    raise ArgumentError, "Hash expected, got #{options.class.name}" if not options.is_a?(Hash) and not options.empty?

    options.reverse_merge! column: :code, scope: nil, initial: 1, force: false

    options[:scope] = [ options[:scope] ] unless options[:scope].is_a? Array

    method_name = "auto_increment_#{options[:column]}"

    before_create method_name

    define_method method_name do
      return if send(options[:column]).present? and !options[:force]

      query = self.class.all

      options[:scope].each do |scope|
        if scope.present? and respond_to?(scope)
          query = query.where(scope => send(scope))
        end
      end

      if options[:initial].class == String
        max = query.select("#{options[:column]} max").order("LENGTH(#{options[:column]}) DESC, #{options[:column]} DESC").first
        max = max.max if max.present?
      else
        max = query.maximum options[:column]
      end

      max = max.blank? ? options[:initial] : max.next

      write_attribute options[:column], max
    end
  end
end

# Extend ActiveRecord's functionality
ActiveRecord::Base.send :extend, AutoIncrement

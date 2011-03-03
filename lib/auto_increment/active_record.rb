require 'active_record'

module AutoIncrement
  def auto_increment(options = {})
    raise ArgumentError, "Hash expected, got #{options.class.name}" if not options.is_a?(Hash) and not options.empty?

    default_options = { :column => :code, :scope => nil, :initial => 1 }
    options = default_options.merge(options) unless options.nil?

    options[:scope] = [options[:scope]] if options[:scope].class != Array

    before_create "auto_increment_#{options[:column]}"

    define_method "auto_increment_#{options[:column]}" do
      return if self.send(options[:column]).present? || self.send(options[:column]) == 0
      query = self.class.scoped
      options[:scope].each do |scope|
        if scope.present? and respond_to?(scope)
          query = query.where "#{scope} = ?", send(scope)
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

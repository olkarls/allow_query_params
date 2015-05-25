module AllowsQueryParam
  attr_accessor :underscore_keys, :mappings

  def allows_query_params(options = {})
    for key, value in options
      send(:"#{key}=", value)
    end

    yield self if block_given?

    if options.has_key?(:underscore_keys)
      @underscore_keys = options[:underscore_keys]
    else
      @underscore_keys = false
    end

    if options.has_key?(:mappings)
      @mappings = options[:mappings]
    else
      @mappings = false
    end

    extend ClassMethods
  end

  module ClassMethods
    def query_by_params(query_string)
      query_params = QueryParams.new(query_string)
      query = self

      query_params.order_by.each do |order|
        if self.column_names.include?(order[:property])
          query = query.order("#{order[:property]} #{order[:direction]}")
        end
      end

      total_count = query.count
      total_pages = (total_count / query_params.page_size).ceil

      data = query
        .limit(query_params.page_size)
        .offset(query_params.page_size * (query_params.page - 1))

      QueryResult.new(data, total_pages, total_count)

    end
  end
end

require 'allows_query_params/query_params'
require 'allows_query_params/query_result'

ActiveRecord::Base.send :extend, AllowsQueryParam

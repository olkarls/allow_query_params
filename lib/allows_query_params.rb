module AllowsQueryParam
  def allows_query_params(options = [])
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

      query = query
        .limit(query_params.page_size)
        .offset(query_params.page_size * (query_params.page - 1))

    end
  end
end

require 'allows_query_params/query_params'

ActiveRecord::Base.send :extend, AllowsQueryParam
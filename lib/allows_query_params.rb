require 'helpers/configuration'

module AllowsQueryParam
  extend Configuration

  define_setting :page_size, 50
  define_setting :maximum_page_size, 100

  def allows_query_params(options = {})
    config = class_variable_set "@@allows_query_param_config", {}

    config[:page_size] = set_option(options, :page_size)
    config[:maximum_page_size] = set_option(options, :maximum_page_size)
    config[:mappings] = options.has_key?(:mapping) ? options[:mapping] : nil

    extend ClassMethods
  end

  module ClassMethods
    def query_by_params(query_string)
      config = class_variable_get "@@allows_query_param_config"

      query_params = QueryParams.new(query_string, config)
      query = self

      query_params.order_by.each do |order|
        if self.column_names.include?(order[:property])
          query = query.order("#{order[:property]} #{order[:direction]}")
        end
      end

      query_params.filters.each do |filter|
        if self.column_names.include?(filter[:property].to_s)
          query = query.where("#{filter[:property]} #{convert_operator(filter[:operator])} '#{filter[:value]}'")
        end
      end

      total_count = query.count
      total_pages = (total_count / query_params.page_size).ceil

      data = query
        .limit(query_params.page_size)
        .offset(query_params.page_size * (query_params.page - 1))

      QueryResult.new(data.to_a, total_pages, total_count)

    end
  end

  private

  def set_option(options, key)
    options.has_key?(key) ? options[key] : AllowsQueryParam.send(key)
  end

  def convert_operator(operator)
    case operator
    when :eq
      '=='
    when :ne
      '!='
    when :gt
      '>'
    when :ge
      '>='
    when :lt
      '<'
    when :le
      '<='
    end
  end
end

require 'allows_query_params/query_params'
require 'allows_query_params/query_result'

ActiveRecord::Base.send :extend, AllowsQueryParam

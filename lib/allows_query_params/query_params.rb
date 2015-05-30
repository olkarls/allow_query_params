require "awesome_print"

class QueryParams
  attr_accessor :order_by, :page, :page_size, :maximum_page_size, :modified_since, :filters

  def initialize(query_string, options = { :page_size => 50, :maximum_page_size => 100 })
    self.page = 1
    self.order_by = []
    self.filters = []
    self.page_size = options[:page_size]
    self.maximum_page_size = options[:maximum_page_size]

    params = CGI::parse(query_string)

    set_order_by(params)
    set_page(params)
    set_page_size(params)
    set_modified_since(params)
    set_filters(params)
  end

  private

  def set_order_by(params)
    if params.has_key?('sortBy')
      sort_strings = params['sortBy'].first.split(',')
      sort_strings.each do |string|
        if string.include?(' ')
          parts = string.split(' ')

          if (parts.last.downcase.strip == 'asc' || parts.last.downcase.strip == 'desc')
            self.order_by << { :property => parts.first, :direction => parts.last.upcase.strip }
          else
            self.order_by << { :property => parts.first, :direction => 'ASC' }
          end
        else
          self.order_by << { :property => string, :direction => 'ASC' }
        end
      end
    end
  end

  def set_page(params)
    if params.has_key?('page')

      page = params['page'].first.to_i
      page = 1 if page == 0

      self.page = page
    end
  end

  def set_page_size(params)
    if params.has_key?('pageSize')
      page_size = params['pageSize'].first.to_i

      self.page_size = page_size if page_size > 0
      self.page_size = self.maximum_page_size if page_size > self.maximum_page_size
    end
  end

  def set_modified_since(params)
    if params.has_key?('modifiedSince')
      begin
        date = DateTime.parse(params['modifiedSince'].first)
        self.modified_since = date
      rescue
        self.modified_since = nil
      end
    end
  end

  def set_filters(params)
    if params.has_key?('filter')
      filters = params['filter'][0].split(',')

      filters.each do |filter|
        parts = filter.split(' ')

        if supported_operators.include?(parts[1].strip.to_sym)
          self.filters << {
            property: parts[0].strip.to_sym,
            operator: parts[1].strip.to_sym,
            value: string_to_type(parts[2].strip)
          }
        end
      end
    end
  end

  def supported_operators
    [:eq, :ne, :gt, :ge, :lt, :le, :not]
  end

  def string_to_type(str)
    type = (Integer(str) rescue Float(str) rescue Time.parse(str) rescue nil)

    if str.downcase == 'true' || str.downcase == 'false'
      return str == 'true'
    end

    type.nil? ? str : type
  end
end

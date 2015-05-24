require "awesome_print"

class QueryParams
  attr_accessor :order_by, :page, :page_size, :modified_since

  MAXIMUM_PAGE_SIZE = 100

  def initialize(query_string)
    self.order_by = []
    self.page = 1
    self.page_size = 50

    params = CGI::parse(query_string)

    set_order_by(params)
    set_page(params)
    set_page_size(params)
    set_modified_since(params)
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

      if page_size > 0
        self.page_size = page_size
      end
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
end
class QueryResult
  attr_accessor :total_pages, :total_count, :data

  def initialize(data, total_pages, total_count)
    @data = data
    @total_pages = total_pages
    @total_count = total_count
  end
end

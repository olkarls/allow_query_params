require 'test_helper'
require 'allows_query_params/query_params'

class QueryParamsTest < MiniTest::Test

  def test_sort_by_with_single_property
    query_string = "sortBy=name"
    query_params = QueryParams.new(query_string)

    assert_equal('name', query_params.order_by.first[:property])
    assert_equal('ASC', query_params.order_by.first[:direction])
  end

  def test_sort_by_with_two_properties
    query_string = "sortBy=name,department%20desc"
    query_params = QueryParams.new(query_string)

    assert_equal('name', query_params.order_by.first[:property])
    assert_equal('ASC', query_params.order_by.first[:direction])

    assert_equal('department', query_params.order_by.last[:property])
    assert_equal('DESC', query_params.order_by.last[:direction])
  end

  def test_sort_by_with_invalid_direction
    query_string = "sortBy=name%20invalid"
    query_params = QueryParams.new(query_string)

    assert_equal('name', query_params.order_by.first[:property])
    assert_equal('ASC', query_params.order_by.first[:direction])
  end

  def test_page_with_valid_input
    query_string = "page=33"
    query_params = QueryParams.new(query_string)

    assert_equal(33, query_params.page)
  end

  def test_page_with_invalid_input
    query_string = "page=abs"
    query_params = QueryParams.new(query_string)

    assert_equal(1, query_params.page)
  end

  def test_page_size_with_normal_number
    query_string = "pageSize=10"
    query_params = QueryParams.new(query_string)

    assert_equal(10, query_params.page_size)
  end

  def test_page_size_with_invalid_number
    query_string = "pageSize=invalid"
    query_params = QueryParams.new(query_string)

    assert_equal(50, query_params.page_size)
  end

  def test_modified_since_with_valid_time
    query_string = "modifiedSince=2010-10-10%2000:00:00"
    query_params = QueryParams.new(query_string)

    assert_equal(DateTime.new(2010, 10, 10, 0, 0, 0), query_params.modified_since)
  end

  def test_modified_since_with_invalid_time
    query_string = "modifiedSince=dddd-sa-as"
    query_params = QueryParams.new(query_string)

    assert_equal(nil, query_params.modified_since)
  end
end
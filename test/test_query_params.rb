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

  def test_page_size_with_too_large_number
    query_string = "pageSize=1000"
    query_params = QueryParams.new(query_string)

    assert_equal(100, query_params.page_size)
  end

  def test_filter_eq_with_int
    query_string = "filter=price eq 26"
    query_params = QueryParams.new(query_string)

    assert_equal([{ property: :price, operator: :eq, value: 26}], query_params.filters)
  end

  def test_filter_eq_with_bool
    query_string = "filter=active eq false"
    query_params = QueryParams.new(query_string)

    assert_equal([{ property: :active, operator: :eq, value: false}], query_params.filters)
  end

  def test_filter_eq_with_float
    query_string = "filter=price eq 100.0"
    query_params = QueryParams.new(query_string)

    assert_equal([{ property: :price, operator: :eq, value: 100.0}], query_params.filters)
  end

  def test_filter_eq_with_date
    query_string = "filter=published eq 2010-10-10 00:46:37"
    query_params = QueryParams.new(query_string)

    assert_equal(DateTime, query_params.filters.first[:value].class)

    expected = DateTime.new(2010, 10, 10, 0, 46, 37)

    assert_equal(expected, query_params.filters.first[:value])

  end

  def test_multiple_filters
    query_string = "filter=price lt 100, name eq headphones"
    query_params = QueryParams.new(query_string)

    expected = [
      { property: :price, operator: :lt, value: 100 },
      { property: :name, operator: :eq, value: 'headphones' }
    ]

    assert_equal(expected, query_params.filters)
  end
end

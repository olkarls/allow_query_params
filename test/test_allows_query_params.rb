# encoding: utf-8

require 'test_helper'

class AllowsQueryParamsTest < MiniTest::Test
  load_schema
  insert_test_data

  def test_defaults
    result = Product.query_by_params('')

    assert_equal(50, result.data.count)
    assert_equal(500, result.total_count)
    assert_equal(10, result.total_pages)
  end

  def test_sort_by_name_asc
    result = Product.query_by_params('sortBy=name')

    assert_equal('a', result.data.first.name[0])
  end

  def test_sort_by_name_desc
    result = Product.query_by_params('sortBy=name desc')

    assert_equal('w', result.data.first.name[0])
  end

  def test_sort_by_price_desc_and_name_desc
    result = Product.query_by_params('sortBy=price desc,name desc')

    max_price = Product.maximum('price')

    assert_equal(max_price, result.data.first.price)
  end

  def test_chain_from_association
    category = Category.first

    result = category.products.query_by_params('sortBy=price desc')

    assert_equal(category.id, result.data.first.category_id)
  end

  def test_filter_eq
    result = Product.query_by_params('filter=price eq 114')

    assert_equal(2, result.total_count)
  end

  def test_filter_ne
    result = Product.query_by_params('filter=price ne 114')

    assert_equal(498, result.total_count)
  end

  def test_filter_gt
    result = Product.query_by_params('filter=price gt 200')

    assert_equal(394, result.total_count)
  end

  def test_filter_ge
    result = Product.query_by_params('filter=price ge 780')

    assert_equal(100, result.total_count)
  end

  def test_filter_lt
    result = Product.query_by_params('filter=price lt 780')

    assert_equal(400, result.total_count)
  end

  def test_filter_le
    result = Product.query_by_params('filter=price le 780')

    assert_equal(401, result.total_count)
  end

  def test_filter_date
    result = Product.query_by_params('filter=updated_at gt 2015-11-11 00:46:53')

    assert_equal(13, result.total_count)
  end
end

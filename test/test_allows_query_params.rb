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

end

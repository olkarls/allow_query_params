# encoding: utf-8

require 'test_helper'

class AllowsQueryParamsTest < MiniTest::Test
  load_schema
  insert_test_data

  def test_defaults
    products = Product.query_by_params('')

    assert_equal(50, products.count)
  end

  def test_sort_by_name_asc
    products = Product.query_by_params('sortBy=name')

    assert_equal('a', products.first.name[0])
  end

  def test_sort_by_name_desc
    products = Product.query_by_params('sortBy=name desc')

    assert_equal('w', products.first.name[0])
  end

  def test_sort_by_price_desc_and_name_desc
    products = Product.query_by_params('sortBy=price desc,name desc')

    max_price = Product.maximum('price')

    assert_equal(max_price, products.first.price)
  end

  def test_chain_from_association
    category = Category.first

    products = category.products.query_by_params('sortBy=price desc')
  end

end
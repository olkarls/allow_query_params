require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'csv'
require 'active_record'
require 'minitest/autorun'
require 'minitest/reporters'
require 'allows_query_params'

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

class Category < ActiveRecord::Base
  has_many :products
end

class Product < ActiveRecord::Base
  allows_query_params
  belongs_to :category
end

def load_schema
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:", :encoding => "utf8")
  load(File.dirname(__FILE__) + "/schema.rb")
end

def insert_test_data

  CSV.foreach('test/categories.csv') do |row|
    Category.create(name: row[0]) if $. > 1
  end

  CSV.foreach('test/products.csv') do |row|
    Product.create(name: row[0], price: row[1], category_id: row[2], gross_weight: row[3], created_at: row[4], updated_at: row[5]) if $. > 1
  end
end

require 'rubygems'
require 'faker'
require 'csv'


CSV.open('categories.csv', 'wb') do |csv|
  csv << ['name']

  20.times do |index|
    csv << ["#{Faker::Company.bs}"]
  end
end

date1 = DateTime.new(2011, 1, 1)
date2 = DateTime.new(2015, 12, 31)

CSV.open('products.csv', 'wb') do |csv|
  csv << ['name', 'price', 'category_id', 'gross_weight', 'created_at', 'updated_at']

  500.times do |index|
    updated_at = date1 + (date2 - date1) * rand
    csv << ["#{Faker::Company.bs}", rand(10...1000), rand(1...20), rand(10...1000), "#{updated_at}", "#{updated_at}"]
  end
end

require 'rubygems'
require 'faker'

20.times do
  puts "Category.create(:name => '#{Faker::Company.bs}'"
end

500.times do
  date1 = DateTime.new(2011, 1, 1)
  date2 = DateTime.new(2015, 12, 31)

  modifed_at = date1 + (date2 - date1) * rand

  puts "Product.create(:name => '#{Faker::Company.bs}', :price => #{rand(10...1000)}, :category_id => #{rand(1...20)}, :gross_weight => #{rand(10...1000)}, :created_at => '#{modifed_at}', :modified_at => '#{modifed_at}')"
end
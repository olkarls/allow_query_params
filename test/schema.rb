ActiveRecord::Schema.define(:version => 0) do
  create_table :products, :force => true do |t|
    t.string :name
    t.float :price
    t.integer :category_id
    t.float :gross_weight

    t.timestamps null: false
  end

  create_table :categories, :force => true do |t|
    t.string :name
  end

  create_table :customer, :force => true do |t|
    t.string :first_name
    t.string :last_name
    t.string :email
  end
end

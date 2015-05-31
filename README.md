# acts_as_queryable

Make your APIs list requests easily queryable.

    http://products?filter=price ge 110&sort=price desc, name asc

```ruby
class Product < ActiveRecord::Base
  acts_as_queryable
end
```

```ruby
def index
  @result = Product.query(params)
end
```

## Sort
...

## Filter
...

## Paginate
...

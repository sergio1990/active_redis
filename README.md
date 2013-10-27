# ActiveRedis

Small childly ORM for Redis

## Installation

Add this line to your application's Gemfile:

    gem 'active_redis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_redis

## Usage

### Basic usage

```ruby
class Article < ActiveRedis::Base
  attributes :title, :link
end
```

By class method __attributes__ you must define own attributes.

### Attribute accessing

By using accessible methods

```ruby
article = Article.new
article.title = "Some title"
article.link = "http://someblog.com/1"

p article.title # => Some title
p article.link # => http://someblog.com/1
```

Or by __attributes__ method

```ruby
article = Article.new
article.attributes = {title: "Some title", link: "http://someblog.com/1"}

p article.attributes # => {title: "Some title", link: "http://someblog.com/1"}
p article.title # => Some title
p article.link # => http://someblog.com/1
```

### Persistence

ActiveRedis::Base inherited model respond to all CRUD method such as create, update, destroy and save

```ruby
article = Article.new(title: "Some title", link: "http://someblog.com/1")
article.save # => true

another_article = Article.create(title: "Another title", link: "http://someblog.com/2") # => true

article.update(title: "New article title") # => true

p article.title # => New article title

another_article.destroy

Article.destroy_all

p Article.count # => 0
```

### Finders and Calculations

You may find 'row' by it's id

```ruby
Article.find(1) # => [#<Article:0x007fec2526f4f8 @updated_at="1382608780", @link="http://someblog.com/1", @id="1", @title="Some title", @created_at="1382608780">]
```

Also gem add support for some aggregation functions like __sum__, __min__, __max__, __pluck__

```ruby
class Article < ActiveRedis::Base
  attributes :link, :title, :views
end

Article.create(views: 1000, link: "http://someblog.com/1", title: "Title article")
Article.create(views: 3000, link: "http://someblog.com/2", title: "Title article")

Article.sum(:views)    # => 4000
Article.min(:views)    # => 1000
Article.max(:views)    # => 3000
Article.pluck(:id)     # => ["1", "2"]
```

From version 0.0.2 you are able to search item by multiple attributes using method __where__

```ruby
Article.where(title: "Title article", views: 1000)
```

### Future work

At an early time I want to implement such features:

1. Add _all_ class method
2. Implement Association module
3. Setting/getting attributes with it's types
4. Relational Operators in where
5. Scopes???

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

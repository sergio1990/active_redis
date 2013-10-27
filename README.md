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
```

### Finders and Calculations

Now you may find 'row' by it's id

```ruby
Article.find(1) # => [#<Article:0x007fec2526f4f8 @updated_at="1382608780", @link="http://someblog.com/1", @id="1", @title="Some title", @created_at="1382608780">]
```

Now gem add support for some aggregation functions like __sum__, __min__, __max__, __pluck__.

### Future work

At an early time I want to implement such features:

1. Add finders like ActiveRecord's where
2. Add _all_ class method
3. Add associations
4. Setting/getting attributes with it's types

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

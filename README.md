# ActiveStoreAccessor

[![Build Status](https://travis-ci.org/jalkoby/active_store_accessor.svg?branch=master)](https://travis-ci.org/jalkoby/active_store_accessor)
[![Gem Version](https://badge.fury.io/rb/active_store_accessor.svg)](http://badge.fury.io/rb/active_store_accessor)
[![Code Climate](https://codeclimate.com/github/jalkoby/active_store_accessor.png)](https://codeclimate.com/github/jalkoby/active_store_accessor)

`active_store_accessor` makes a work with store accessors more productive. There is no need to cast a serialized attribute to a required type(boolean, time, float, etc). Just define it with a tiny wrapper method and everything is done for you.

## Usage

The basic usage:

```ruby
class Profile < ActiveRecord::Base
  active_store_accessor :info, age: :integer, birthday: :time

  # with default values
  active_store_accessor :info, score: { type: :float, default: 0.0 },
    active: { type: :boolean, default: true }
end

profile = Profile.new
profile.age = "23"
profile.age # => 23
profile.birthday = Time.new(2014, 5, 31)
profile.birthday # => 2014-05-31 00:00:00
profile.score # => 0.0
profile.score = 4.5
profile.score # => 4.5
```

The extra logic in a property methods:
```ruby
# Story:
#  users have a rank, but if a user was locked by admins
#  nobody can change a rank & it's value should be equal to zero
class User
  active_store_accessor :info, rank: :float

  def rank
    0 if locked?
    super
  end

  def rank=(value)
    super unless locked?
  end
end
```

## Adding a custom type
Add a custom type is easy enough:

```ruby
# using a block
ActiveStoreAccessor.add_type(:even) do |builder|
  builder.to_source { |value| (value.to_i / 2) * 2 }
end

# using a lambda
ActiveStoreAccessor.add_type(:even) do |builder|
  to_source = lambda { |value| (value.to_i / 2) * 2 }
  builder.to_source(to_source)
end

# using a object with #call method
class EvenConvert
  def call(value)
    (value.to_i / 2) * 2
  end
end

ActiveStoreAccessor.add_type(:even) do |builder|
  builder.to_source(EvenConvert.new)
end
```

Sometimes you need to deserialize your value of a custom type. To do it look at the following example:

```ruby
ActiveStoreAccessor.add_type(:point) do |builder|
  builder.to_source do |value|
    "#{ value.x },#{ value.y }"
  end

  builder.from_source do |value|
    parts = value.split(',')
    Point.new(parts[0], parts[1])
  end
end
```

There is a common issue when you use `block`-style to define a custom type:

```ruby
ActiveStoreAccessor.add_type(:point) |builder|
  builder.to_source do |value|
    return unless value.is_a?(Point)
    # ...
  end
end
```

Ruby will rise an error Unexpected Return (LocalJumpError). To avoid it replace a block by a lambda:

```ruby
ActiveStoreAccessor.add_type(:point) |builder|
  to_source = lambda do |value|
    return unless value.is_a?(Point)
    # ...
  end

  builder.to_source(to_source)
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'active_store_accessor'

And then execute:

    $ bundle

## Requirements & dependencies

This library has been tested on ruby 1.9.3+ and activerecord 4.0+.

## Contributing

1. Fork it ( https://github.com/jalkoby/active_store_accessor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

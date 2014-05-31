# ActiveStoreAccessor

[![Build Status](https://travis-ci.org/jalkoby/active_store_accessor.svg?branch=master)](https://travis-ci.org/jalkoby/active_store_accessor)
[![Gem Version](https://badge.fury.io/rb/active_store_accessor.svg)](http://badge.fury.io/rb/active_store_accessor)
[![Code Climate](https://codeclimate.com/github/jalkoby/active_store_accessor.png)](https://codeclimate.com/github/jalkoby/active_store_accessor)

With `active_store_accessor` you can have boolean, integer, float, time store attributes which would act like a regular schema columns.  

## Installation

Add this line to your application's Gemfile:

    gem 'active_store_accessor'

And then execute:

    $ bundle

## Usage

After you add gem into Gemfile everything is done for you. Now you can declare your serialized properties in a next way:

```ruby
class Profile < ActiveRecord::Base
  # basic usage(where `info` is a store column)
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

## Requirements & dependencies

This library has been tested on ruby 1.9.3+ and activerecord 3.2+. Any other configurations might have potential issues. `active_store_accessor` doesn't have any external dependency(expect activerecord) and contains only one file with one module.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_store_accessor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

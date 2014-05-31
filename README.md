# ActiveStoreAccessor

Get more from ActiveRecord::Store

## Installation

Add this line to your application's Gemfile:

    gem 'active_store_accessor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_store_accessor

## Usage

After you add gem into Gemfile everything is done for you. Now you can declare your serialized properties in a next way:

    # basic usage(where `info` is a store column)
    active_store_accessor :info, age: :integer, birthday: :time

    # with default values
    active_store_accessor :info, score: { type: :float, default: 0.0 }, active: { type: :boolean, default: true }

## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_store_accessor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

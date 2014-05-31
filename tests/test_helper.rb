require "minitest/autorun"
require "active_record"
require "active_store_accessor"

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :profiles do |t|
    t.text :info
  end
end

class Profile < ActiveRecord::Base
  active_store_accessor :info, age: :integer, score: { type: :integer, default: 10 }
  active_store_accessor :info, rank: :float
  active_store_accessor :info, birthday: :time
  active_store_accessor :info, confirmed: :boolean
end

class AdminProfile < Profile
  active_store_accessor :info, level: :integer
end

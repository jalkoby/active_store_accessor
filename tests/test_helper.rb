require "minitest/autorun"
require "active_record"
require "active_store_accessor"

ActiveRecord::Base.establish_connection(adapter: 'postgresql', database: 'asa_test', user: 'rails')
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.connection.execute "drop schema public cascade"
ActiveRecord::Base.connection.execute "create schema public"
ActiveRecord::Base.connection.execute "CREATE EXTENSION IF NOT EXISTS hstore"

ActiveRecord::Schema.define do
  enable_extension "hstore"

  create_table :profiles do |t|
    t.text :info
    t.hstore :keys
  end
end

class Profile < ActiveRecord::Base
  active_store_accessor :info, age: :integer, score: { type: :integer, default: 10 }
  active_store_accessor :info, rank: :float
  active_store_accessor :info, birthday: :time
  active_store_accessor :info, confirmed: :boolean

  active_store_accessor :keys, active: :boolean
  active_store_accessor :keys, pi: :float

  def rank=(value)
    super(value)
    super(rank.round(2)) if rank
  end
end

class AdminProfile < Profile
  active_store_accessor :info, level: :integer
end

class UserProfile < Profile
  active_store_accessor :data, level: :integer
end

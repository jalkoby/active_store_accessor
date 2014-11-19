source 'https://rubygems.org'

# Specify your gem's dependencies in active_store_accessor.gemspec

ar_version = ENV["AR_VERSION"]
ar_version = case ar_version
  when "4.0" then "~> 4.0.0"
  when "4.2" then "~> 4.2.0.beta4"
  else
    "~> 4.1.0"
  end
gem "activerecord", ar_version, require: ["active_record", "active_support/all"]
gem "pg"

gemspec

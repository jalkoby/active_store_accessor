source 'https://rubygems.org'

# Specify your gem's dependencies in active_store_accessor.gemspec
gemspec

ar_version = ENV["AR_VERSION"]
ar_version = case ar_version
  when "3.2" then "~> 3.2.0"
  when "4.0" then "~> 4.0.0"
  else
    "~> 4.1.0"
  end
gem "activerecord", ar_version

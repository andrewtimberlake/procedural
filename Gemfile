source "http://rubygems.org"

# Specify your gem's dependencies in spectacles.gemspec
gemspec

platforms :jruby do
  gem "activerecord-jdbcpostgresql-adapter"
end

platforms :ruby do
  gem "pg"
end

group :test do
  gem 'simplecov',            require: false
end

version = ENV['RAILS_VERSION'] || 'default'

case version
when 'default'
  gem 'activerecord', '>= 4.2'
else
  gem 'activerecord', "~> #{version}"
end

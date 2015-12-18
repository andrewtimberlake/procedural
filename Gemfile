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

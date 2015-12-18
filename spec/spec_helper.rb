require 'yaml'
require 'simplecov'
SimpleCov.start do
  add_filter "/spec"
end

require 'rubygems'
require 'bundler'
Bundler.require(:default, :development, :test)

# TODO: I shouldn't have to do this
require 'active_record/connection_adapters/postgresql_adapter'

require 'minitest/autorun'
require 'minitest/spec/expect'
require 'support/minitest_shared'
require 'support/minitest_matchers'
require 'support/migration_helpers'

ActiveRecord::Schema.verbose = false

def configure_database(adapter)
  config_path = File.expand_path(File.join(__dir__, 'database.yml'))
  # puts "config_path: #{config_path.inspect}"
  config = YAML.load(File.read(config_path))
  # puts "config[#{adapter.inspect}]: #{config[adapter.to_s].inspect}"
  @database_config = config[adapter.to_s]
end

def recreate_database(database)
  ActiveRecord::Base.establish_connection(@database_config)
  ActiveRecord::Base.connection.drop_database(database) rescue nil
  ActiveRecord::Base.connection.create_database(database)
  ActiveRecord::Base.establish_connection(@database_config.merge(:database => database))
end

def load_schema
  ActiveRecord::Schema.define(:version => 1) do
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
    end
  end
end

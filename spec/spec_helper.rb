# ENV['RAILS_ENV'] = 'test'

require File.expand_path("../rails_app/config/environment.rb",  __FILE__)

require "bundler"
Bundler.setup

require 'rspec'
require "rspec/rails"
require 'active_support/core_ext'
require "governor"

Rspec.configure do |config|
  config.mock_with :mocha
end


# require 'rails'

# require 'rails/test_help'
# require 'active_support/core_ext'

# ActiveRecord::Migrator.migrate File.expand_path(File.dirname(__FILE__), 'rails_app/db/migrate/')
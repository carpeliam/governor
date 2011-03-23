require "bundler"
Bundler.setup

require 'rspec'
# require "rspec/rails"
require 'active_support/core_ext'
require "governor"

Rspec.configure do |config|
  config.mock_with :mocha
end
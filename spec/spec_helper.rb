require "bundler"
Bundler.setup

require "rspec"
require 'active_support/core_ext'
require "governor"
# require "support/matchers"

Rspec.configure do |config|
  # config.include NewGem::Spec::Matchers
  config.mock_with :mocha
end
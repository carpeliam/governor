ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../rails_app/config/environment.rb',  __FILE__)

require 'bundler'
Bundler.setup

require 'rspec'
require 'rspec/rails'
# require 'active_support/core_ext'
# require 'rails/test_help'

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

ActiveRecord::Migrator.migrate File.expand_path('../rails_app/db/migrate/', __FILE__)

Rspec.configure do |config|
  config.mock_with :mocha
  
  config.use_transactional_fixtures = true
end

# for removing plugins added in a test to make sure they don't bleed over
module Governor
  class PluginManager
    def self.remove_plugin(plugin_or_name)
      case plugin_or_name
      when Plugin then return @@plugins.delete(plugin_or_name)
      else # Plugin Name
        @@plugins.each do |plugin|
          return @@plugins.delete(plugin) if plugin.name == plugin_or_name
        end
      end
    end
  end
end
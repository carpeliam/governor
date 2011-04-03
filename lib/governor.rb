require 'governor/plugin'
require 'governor/plugin_manager'
require 'governor/article'
require 'governor/formatters'
require 'governor/mapping'

require 'governor/controllers/helpers'

require 'rails'
require 'governor/rails'


module Governor
  
  mattr_accessor :resources, :authorization_rules
  @@resources = {}
  def self.map(resource, options = {})
    self.resources[resource] = Governor::Mapping.new(resource, options)
  end
  
  def self.authorize_if(&blk)
    @@authorization_rules = blk
  end
end
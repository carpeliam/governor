require 'governor/plugin'
require 'governor/plugin_manager'
require 'governor/article'
require 'governor/formatters'
require 'governor/mapping'

require 'governor/controllers/helpers'

require 'rails'
require 'governor/rails'


module Governor
  
  mattr_accessor :resources
  @@resources = {}
  def self.map(resource, options = {})
    self.resources[resource] = Governor::Mapping.new(resource, options)
  end
  
  def self.setup
    yield self
  end
  
  def self.authorize_if(&blk)
    @@authz_rules = blk
  end
  
  def self.authorized?(actor, action, article=nil)
    @@authz_rules.call(actor, action, article)
  end
end
# For testing purposes:
plugin = Governor::Plugin.new('xml support')
plugin.responds_to :xml, :only => [:index]
Governor::PluginManager.register plugin
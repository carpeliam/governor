module Governor
  class PluginManager
    cattr_reader :plugins
    
    class << self
      @@plugins = []
      
      # Registers the given plugins with Governor. Usually called within the
      # context of a single plugin, but any number of plugins can be
      # registered.
      #
      # Example:
      #
      #     comments = Governor::Plugin.new('comments')
      #     Governor::PluginManager.register comments
      #
      def register(*plugins)
        @@plugins += plugins
      end
    end
  end
end
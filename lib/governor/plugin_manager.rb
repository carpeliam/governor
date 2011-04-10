module Governor
  class PluginManager
    cattr_reader :plugins
    cattr_reader :view_hooks
    
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
      
      # A convenience method for obtaining the resources for plugins.
      #
      # Example:
      #
      #     comments = Governor::Plugin.new('comments')
      #     comments.add_child_resource :comments, :path_names => {:create => 'comment'}
      #     Governor::PluginManager.register comments
      #     Governor::PluginManager.resources(:child_resources) # => {:comments => {:create => 'comment'}}
      def resources(name)
        @@plugins.map{|p| p.resources[name] }.compact.reduce({}, :merge)
      end
    end
  end
end
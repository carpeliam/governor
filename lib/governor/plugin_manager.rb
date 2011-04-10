module Governor
  class PluginManager
    cattr_reader :plugins
    cattr_reader :view_hooks
    
    class << self
      @@plugins = []
      
      def register(*plugins)
        @@plugins += plugins
      end
      
      def resources(name)
        @@plugins.map{|p| p.resources[name] }.compact.reduce({}, :merge)
      end
    end
  end
end
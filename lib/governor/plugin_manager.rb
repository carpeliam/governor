module Governor
  class PluginManager
    cattr_reader :plugins
    cattr_reader :view_hooks
    
    class << self
      def initialize
        @@view_hooks = {}
      end
      
      def register(plugin)
        @@plugins ||= []
        @@plugins << plugin
      end
      
      def register_partial(where, partial_path)
        @@view_hooks ||= {}
        @@view_hooks[where] ||= []
        @@view_hooks[where] << partial_path
      end
    end
  end
end
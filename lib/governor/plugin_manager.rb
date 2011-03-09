module Governor
  class PluginManager
    cattr_reader :plugins
    
    class << self
      def register(plugin)
        @@plugins ||= []
        @@plugins << plugin
      end
    end
  end
end
module Governor
  module Controllers
    module Methods
      def self.included(base) #:nodoc:
        Governor::PluginManager.plugins.each do |plugin|
          plugin.include_in_controller(base)
        end
      end
    end
  end
end
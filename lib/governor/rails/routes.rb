module ActionDispatch #:nodoc:
  module Routing #:nodoc:
    class Mapper
      # Attach a Governor-based resource to your application's Rails routes.
      #
      # Example:
      #
      #     RailsApp::Application.routes.draw do
      #       # ...
      #       governate :articles
      #       # ...
      #     end
      #
      # This will attach a controller that will create and modify Article
      # objects.
      def governate(*resources)
        options = resources.extract_options!
        resources.map!(&:to_sym)
        resources.each do |resource|
          mapping = Governor.map(resource, options)
          resources mapping.resource, :controller => mapping.controller, :governor_mapping => resource do
            Governor::PluginManager.resources(:child_resources).each_pair do |child_resource, options|
              options = {:module => :governor}.merge options
              block = options.delete :block
              resources(child_resource, options) do
                instance_eval(&block) if block.present?
              end
            end
          end
        end
      end
    end
  end
end
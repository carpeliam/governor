module ActionDispatch::Routing
  class Mapper
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

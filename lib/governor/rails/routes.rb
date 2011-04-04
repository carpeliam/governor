module ActionDispatch::Routing
  class Mapper
    def governate(*resources)
      options = resources.extract_options!
      resources.map!(&:to_sym)
      resources.each do |resource|
        mapping = Governor.map(resource, options)
        resources mapping.resource, :controller => mapping.controller, :governor_mapping => resource do
          Governor::PluginManager.plugins.map{|p| p.routes[:child_resources] }.each do |routes|
            routes.each_pair do |child_resource, options|
              resources(child_resource, options)
            end
          end
        end
      end
    end
  end
end

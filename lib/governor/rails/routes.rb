module ActionDispatch::Routing
  class Mapper
    def governate(*resources)
      options = resources.extract_options!
      resources.map!(&:to_sym)
      resources.each do |resource|
        mapping = Governor.map(resource, options)
        resources mapping.resource, :controller => mapping.controller, :governor_mapping => resource
      end
    end
  end
end

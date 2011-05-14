module Governor
  class Mapping
    attr_reader :singular, :plural, :path, :controller, :path_names, :class_name
    alias :resource :plural
    
    def initialize(resource, options = {})
      @plural   = (options[:as] ? "#{options[:as]}_#{resource}" : resource).to_sym
      @singular = (options[:singular] || @plural.to_s.singularize).to_sym
      
      @class_name = (options[:class_name] || resource.to_s.classify).to_s
      @ref = defined?(ActiveSupport::Dependencies::ClassCache) ?
        ActiveSupport::Dependencies::Reference.store(@class_name) :
        ActiveSupport::Dependencies.ref(@class_name)
      
      @path = (options[:path] || resource).to_s
      @path_prefix = options[:path_prefix]
      
      @controller = options[:controller] || 'governor/articles'
    end
    
    # Provides the resource class.
    def to
      if defined?(ActiveSupport::Dependencies::ClassCache)
        @ref.get @class_name
      else
        @ref.get
      end
    end
    
    # Presents a human-readable identifier of the resource type.
    def humanize
      @singular.to_s.humanize
    end
  end
end
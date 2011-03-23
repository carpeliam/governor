module Governor
  class Mapping
    attr_reader :singular, :plural, :path, :controller, :path_names, :class_name
    alias :resource :plural
    
    def initialize(resource, options = {})
      @plural   = (options[:as] ? "#{options[:as]}_#{resource}" : resource).to_sym
      @singular = (options[:singular] || @plural.to_s.singularize).to_sym
      
      @class_name = (options[:class_name] || resource.to_s.classify).to_s
      @ref = ActiveSupport::Dependencies.ref(@class_name)
      
      @path = (options[:path] || resource).to_s
      @path_prefix = options[:path_prefix]
      
      @controller = options[:controller] || 'governor/articles'
    end
    
    def fullpath
      "#{@path_prefix}/#{@path}".squeeze("/")
    end
    
    def to
      @ref.get
    end
    
    def humanize
      @singular.to_s.humanize
    end
    
  end
end
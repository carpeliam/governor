module Governor
  class Plugin
    attr_reader :name, :migrations, :resources, :helpers
    def initialize(name)
      @name = name
      @migrations = []
      @helpers = []
      @resources = {}
      @partials = {}
    end
    
    def add_migration(path)
      @migrations << path
    end
    
    def add_child_resource(name, options={}, &block)
      options[:block] = block if block_given?
      @resources[:child_resources] ||= {}
      @resources[:child_resources][name] = options
    end
    
    def register_partial(type, path)
      @partials[type.to_sym] = path
    end
    
    def partial_for(type)
      @partials[type.to_sym]
    end
    
    def add_helper(mod)
      @helpers << mod
    end
  end
end
module Governor
  class Plugin
    attr_reader :name, :migrations, :routes
    def initialize(name)
      @name = name
      @migrations = []
      @routes = {}
    end
    
    def add_migration(path)
      @migrations << path
    end
    
    def add_child_resource(name, options={})
      @routes[:child_resources] ||= {}
      @routes[:child_resources][name] = options
    end
  end
end
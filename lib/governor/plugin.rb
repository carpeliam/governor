module Governor
  class Plugin
    attr_reader :name, :migrations
    def initialize(name)
      @name = name
      @migrations = []
    end
    
    def add_migration(path)
      @migrations << path
    end
  end
end
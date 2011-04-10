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
    
    # Adds a nested resource. Any options are passed directly to the router.
    # Any member or collection routes can be passed in as a block.
    #
    # Example:
    #
    #     comments = Governor::Plugin.new('comments')
    #     comments.add_child_resource :comments do
    #       member do
    #         put 'mark_spam', 'not_spam'
    #       end
    #     end
    #
    def add_child_resource(name, options={}, &block)
      options[:block] = block if block_given?
      @resources[:child_resources] ||= {}
      @resources[:child_resources][name] = options
    end
    
    # Specifies that this plugin will display a partial of the given type, at
    # the given path. This path is relative to the views directory underneath
    # your app; it's expected that there will be a governor directory
    # underneath views as well.
    #
    # DOCUMENTME I need to indicate which types are supported.
    #
    # Example:
    #
    #     comments.register_partial :after_article_whole, 'articles/comments'
    #
    def register_partial(type, path)
      @partials[type.to_sym] = path
    end
    
    # Returns the path associated with the given partial type.
    #
    # Example:
    #
    #     comments.partial_for(:after_article_whole) # => 'articles/comments'
    #
    def partial_for(type)
      @partials[type.to_sym]
    end
    
    # Associates a helper for this plugin, to be included into the controller
    # and view.
    #
    # Currently this requires a string. This will be refactored soon.
    #
    # Example:
    #
    #     comments.add_helper "GovernorCommentsHelper"
    #
    def add_helper(mod)
      @helpers << mod
    end
  end
end
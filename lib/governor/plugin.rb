module Governor
  class Plugin
    attr_reader :name, :migrations, :routes, :resources, :helpers, :mimes
    def initialize(name)
      @name = name
      @migrations = []
      @helpers = []
      @resources = {}
      @partials = {}
      @mimes = []
    end
    
    def add_migration(path)
      @migrations << path
    end
    
    # Adds routes for articles. These can add member or collection routes to
    # articles, or even nested resources.
    #
    # Example:
    #
    #     comments = Governor::Plugin.new('comments')
    #     comments.set_routes do
    #       resources :comments do
    #         member do
    #           put 'mark_spam', 'not_spam'
    #         end
    #       end
    #     end
    #
    def set_routes(&block)
      @routes = block
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
    
    def partial_for(type) #:nodoc:
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
    
    def include_in_model(base) #:nodoc:
      instance_exec(base, &@model_callback) if @model_callback
    end
    
    # Evaluates the block in the scope of the model. This is the equivalent of
    # creating a mixin, including it within your article class and
    # implementing +self.included+.
    #
    # Example:
    #
    #     thinking_sphinx = Governor::Plugin.new('thinking_sphinx')
    #     thinking_sphinx.register_model_callback do |base|
    #       base.define_index do
    #         indexes title
    #         indexes description
    #         indexes post
    #         has created_at
    #         set_property :delta => true
    #       end
    #     end
    def register_model_callback(&block)
      @model_callback = block
    end
    
    def responds_to(*mimes)
      @mimes << mimes
    end
  end
end
module Governor
  class Plugin
    attr_reader :name, :migrations, :routes, :resources, :mimes, :navigation_hook
    def initialize(name)
      @name = name
      @migrations = []
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
    
    def include_in_model(base) #:nodoc:
      instance_exec(base, &@model_callback) if @model_callback
    end
    
    def include_in_controller(base) #:nodoc:
      instance_exec(base, &@controller_callback) if @controller_callback
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
    
    def register_controller_callback(&block)
      @controller_callback = block
    end
    
    # Defines mime types that this plugin responds to. These mime types will
    # be passed on to the controller.
    #
    # Example:
    #
    #    plugin.responds_to :xml, :json
    #
    # Specifies that this plugin can deliver a view for XML documents as well
    # as JSON.
    #
    # Any arguments that can be passed to +respond_to+ in the controller can
    # be passed here:
    #
    #     plugin.responds_to :atom, :only => :index
    #
    # This specifies that the :index action responds to :atom, but no others.
    def responds_to(*mimes)
      @mimes << mimes
    end
    
    # Adds the given block to the Governor navigation header in
    # GovernorApplicationHeader#governor_header.
    #
    # Example:
    #
    #     plugin.add_to_navigation do
    #       concat(link_to("Rod's favorite movie?", 'http://www.imdb.com/title/tt0031679/'))
    #     end
    #
    # This would add a link to Rod's favorite movie in the Governor navigation
    # header. You're responsible for wrapping any content you want included
    # with concat().
    def add_to_navigation(&block)
      @navigation_hook = block
    end
  end
end
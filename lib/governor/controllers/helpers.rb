module Governor
  module Controllers #:nodoc:
    module Helpers
      # Represents the article for this session. Can also be accessed as an
      # instance variable, for example <code>@article</code> if the Mapping
      # class is Article.
      def resource
        instance_variable_get("@#{mapping.singular}")
      end
      
      # Returns a symbol representation of this resource, for example
      # <code>:article</code> if the Mapping class is Article.
      def resource_sym
        mapping.singular
      end
      
      # Returns the list of articles for this session. Can also be accessed as
      # an instance variable, for example <code>@articles</code> if the
      # Mapping class is Article.
      def resources
        instance_variable_get("@#{mapping.plural}")
      end
      
      # Returns the Mapping model class, for example: Article.
      def model_class
        @model_class ||= mapping.to
      end

      private
      def set_resources(resources)
        instance_variable_set("@#{mapping.plural}", resources)
      end

      def set_resource(resource)
        instance_variable_set("@#{mapping.singular}", resource)
      end

      def mapping
        Governor.resources[params[:governor_mapping]]
      end

      def init_resource
        set_resource model_class.find(params["#{mapping.singular}_id"] || params[:id])
      end
      
      def the_governor
        instance_eval(&Governor.author)
      end
      
      def governor_logged_in?
        the_governor.present?
      end

      def authorize_governor!
        if defined?(resource)
          redirect_to root_path unless governor_authorized?(action_name, resource)
        else
          instance_eval(&Governor.if_not_allowed) unless governor_authorized?(action_name)
        end
      end
      
      def governor_authorized?(action, article=nil)
        instance_exec(action, article, &Governor.authorization_rules)
      end
    end
  end
end
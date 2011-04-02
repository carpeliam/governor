module Governor
  module Controllers
    module Helpers
      def resources_url
        url_for :controller => mapping.controller, :governor_mapping => params[:governor_mapping], :action => 'index'
      end

      def resource
        instance_variable_get("@#{mapping.singular}")
      end

      def resources
        instance_variable_get("@#{mapping.plural}")
      end

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
        set_resource model_class.find(params[:id])
      end

      def authorize_governor!
        if defined?(resource)
          redirect_to root_path unless governor_authorized?(action_name, resource)
        else
          send("authenticate_#{Devise.default_scope}!") unless governor_authorized?(action_name)
        end
      end
      
      def governor_authorized?(action, article=nil)
        Governor.authorized?(self, action, article)
      end
    end
  end
end
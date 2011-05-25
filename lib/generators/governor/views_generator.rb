module Governor
  class ViewsGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../app/views', __FILE__)
    desc 'Copies Governor views to your application.'
    # argument :resource, :type => :string, :default => Governor.default_resource.plural.to_s

    def copy_views
      directory 'governor', "app/views/governor"
    end
    
    # private
    # def mapping
    #   Governor.resources[resource.pluralize.to_sym]
    # end
  end
end

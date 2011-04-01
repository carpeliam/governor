require 'rails/generators'
require 'rails/generators/migration'
module Governor
  class CreateArticlesGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    argument :class_name, :type => :string, :default => 'Article'
  
    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.new.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
    
    def create_model
      template 'models/article.rb', "app/models/#{table_name.singularize}.rb"
    end
  
    def create_migration_file
      migration_template 'migrations/create_articles.rb', "db/migrate/governor_create_#{table_name}.rb", :skip => true
    end
    
    def add_route
      # route "resources :#{table_name}, :controller => 'governor/articles'"
      route "governate :#{table_name}"
    end
    
    private
    def table_name
      @table_name ||= class_name.tableize
    end
    
    def model_name
      @model_name ||= class_name.camelize
    end
    
  end
end
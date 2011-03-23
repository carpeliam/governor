module Governor
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
  
    def copy_initializer
      template 'governor.rb', 'config/initializers/governor.rb'
    end
  end
end
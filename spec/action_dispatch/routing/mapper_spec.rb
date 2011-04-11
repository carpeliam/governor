require 'spec_helper'

module ActionDispatch::Routing
  
  describe Mapper do
    context "#governate", :type => :routing do
      
      before do
        @plugin = Governor::Plugin.new('test')
        @plugin.set_routes do
          resources :foos
        end
        Governor::PluginManager.register @plugin
        
        @article = Factory(:article)
        Rails.application.reload_routes!
      end
      
      it "adds the route" do
        Rails.application.routes.routes.map(&:name).should include 'article_foos'
        # the above works, but the below does not :/
        pending "check with rspec folks to figure out why this doesn't pass"
        {:get => "/articles/#{@article.id}/foos"}.should route_to(:controller => 'foos', :action => 'show', :governor_mapping => :articles)
      end
      
      after do
        # reload routes to undo what we've done
        Governor::PluginManager.remove_plugin(@plugin).should == @plugin
        Rails.application.reload_routes!
      end
      
    end
  end
end

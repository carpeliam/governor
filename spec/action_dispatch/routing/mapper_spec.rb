require 'spec_helper'

module ActionDispatch::Routing
  
  describe Mapper do
    context "#governate" do
      
      before do
        @plugin = Governor::Plugin.new('test')
        @plugin.add_child_resource('test', :some_option => 'value')
        Governor::PluginManager.register @plugin
      end
      
      it "doesn't alter a plugin's options" do
        Rails.application.reload_routes!
        
        @plugin.resources[:child_resources].should == {'test' => {:some_option => 'value'}}
      end
      
      after do
        # reload routes to undo what we've done
        Governor::PluginManager.remove_plugin(@plugin).should == @plugin
        Rails.application.reload_routes!
      end
      
    end
  end
end

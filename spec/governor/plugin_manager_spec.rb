require 'spec_helper'

module Governor
  describe PluginManager do
    before do
      @plugins = Governor::PluginManager.plugins
    end
    
    it "should keep track of plugins I've added" do
      plugin = Plugin.new('test 1')
      PluginManager.register plugin
      PluginManager.plugins.should include plugin
    end
    
    after do
      remove_plugins = Governor::PluginManager.plugins - @plugins
      remove_plugins.each do |plugin|
        Governor::PluginManager.remove_plugin(plugin).should == plugin
      end
    end
  end
end
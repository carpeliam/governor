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
    
    it "collects resources for plugins" do
      plugin1 = Plugin.new('test 1')
      plugin1.add_child_resource(:moneys)
      plugin2 = Plugin.new('test 2')
      plugin2.add_child_resource(:powers, :module => :illinois)
      PluginManager.register plugin1, plugin2
      PluginManager.resources(:child_resources).should == {:moneys => {}, :powers => {:module => :illinois}}
    end
    
    after do
      remove_plugins = Governor::PluginManager.plugins - @plugins
      remove_plugins.each do |plugin|
        Governor::PluginManager.remove_plugin(plugin).should == plugin
      end
    end
  end
end
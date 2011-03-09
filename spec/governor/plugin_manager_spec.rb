require 'spec_helper'

module Governor
  describe PluginManager do
    it "should keep track of plugins I've added" do
      plugin = Plugin.new('my plugin')
      PluginManager.register plugin
      PluginManager.plugins.should include plugin
    end
  end
end
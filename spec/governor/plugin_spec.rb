require 'spec_helper'

module Governor
  describe Plugin do
    before(:each) {@plugin = Plugin.new('test')}
    it "collects child resources" do
      @plugin.add_child_resource('tests', :controller => 'governor/tests')
      @plugin.resources.should == {:child_resources => {'tests' => {:controller => 'governor/tests'}}}
    end
  end
end
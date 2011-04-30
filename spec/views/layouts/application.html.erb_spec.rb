require 'spec_helper'

describe "layouts/application.html.erb" do
  include Devise::TestHelpers
  
  before(:each) do
    sign_in Factory(:user)
  end
  
  it "includes the helper" do
    view.should respond_to(:governor_header)
  end
  
  it "links to articles page" do
    render
    rendered.should have_selector('a', :href => articles_path, :content => 'Articles')
  end
  
  it "links to new article page" do
    render
    rendered.should have_selector('a', :href => new_article_path, :content => 'New Article')
  end
  
  context "with a plugin that adds a hook" do
    before do
      @test = Governor::Plugin.new('test')
      @test.add_to_navigation do
        concat(link_to('Google', 'http://www.google.com'))
      end
      Governor::PluginManager.register @test
    end
    it "shows any plugin's hooks" do
      render
      rendered.should have_selector('a', :href => 'http://www.google.com', :content => 'Google')
    end
    after do
      Governor::PluginManager.remove_plugin(@test)
    end
  end
end
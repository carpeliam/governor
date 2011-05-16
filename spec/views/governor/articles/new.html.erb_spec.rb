require 'spec_helper'

class ActionView::Base
  include Governor::Controllers::Helpers
  
  def params
    {:governor_mapping => :articles}
  end
end

module Governor
  describe "governor/articles/new.html.erb" do
    include Devise::TestHelpers
    
    before(:each) do
      @user = Factory(:user)
      @article = ::Article.new
      assign(:article, @article)
      controller.stubs(:action_name).returns('new')
      sign_in @user
      render
    end
    
    it "shows the form" do
      rendered.should =~ /New article/
    end
  end
end
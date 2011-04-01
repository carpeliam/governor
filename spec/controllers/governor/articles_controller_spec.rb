require 'spec_helper'

module Governor
  describe ArticlesController do
    context "#index" do
      it "assigns the correct instance variable" do
        get :index, :governor_mapping => :articles
        assigns[:articles].should == []
      end
    end
    
    context "#new" do
      it "assigns the correct instance variable" do
        get :new, :governor_mapping => :articles
        assigns[:article].should be_a ::Article
        assigns[:article].attributes.should == ::Article.new.attributes
      end
    end
  end
end
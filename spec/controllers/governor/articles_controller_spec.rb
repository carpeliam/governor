require 'spec_helper'

# we're going to need 'self' later
ARTICLES_CONTROLLER_SPEC = self

module Governor
  describe ArticlesController do
    before(:each) { @article = Factory(:article) }
    context "#index" do
      it "assigns the correct instance variable" do
        get :index, :governor_mapping => :articles
        assigns[:articles].should == [@article]
      end
    end
    
    context "#new" do
      it "assigns the correct instance variable" do
        get :new, :governor_mapping => :articles
        assigns[:article].should be_a ::Article
        assigns[:article].attributes.should == ::Article.new.attributes
      end
    end
    
    %w(show edit).each do |action|
      context "##{action}" do
        it "assigns the correct instance variable" do
          get action, :governor_mapping => :articles, :id => @article.id
          assigns[:article].should == @article
        end
      end
    end
    
    context "#create" do
      it "creates a new instance of Article" do
        # ARTICLES_CONTROLLER_SPEC.expects(:user_signed_in?).returns true
        author = Factory(:user)
        ARTICLES_CONTROLLER_SPEC.expects(:current_user).returns author
        post :create, :governor_mapping => :articles
        assigns[:article].should be_a ::Article
        assigns[:article].should_not be_a_new_record
        assigns[:article].author.should == author
        pending "check authz"
      end
    end
    
    context "#update" do
      it "updates the article" do
        put :update, :governor_mapping => :articles, :id => @article.id, :article => {:title => 'I am awesome, you are awesome'}
        assigns[:article].title.should == 'I am awesome, you are awesome'
      end
    end
    
    context "#destroy" do
      it "deletes the article" do
        delete :destroy, :governor_mapping => :articles, :id => @article.id
        assigns[:article].should == @article
        assigns[:article].should be_destroyed
        ::Article.count.should == 0
      end
    end
  end
end
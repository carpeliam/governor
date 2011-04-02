require 'spec_helper'

module Governor
  describe ArticlesController do
    include Devise::TestHelpers
    
    before(:each) do
      @user = Factory(:user)
      @article = Factory(:article, :author => @user)
    end
    context "#index" do
      it "assigns the correct instance variable" do
        get :index, :governor_mapping => :articles
        assigns[:articles].should == [@article]
      end
    end
    
    context "#new" do
      it "assigns the correct instance variable" do
        sign_in @user
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
        sign_in @user
        post :create, :governor_mapping => :articles
        assigns[:article].should be_a ::Article
        assigns[:article].should_not be_a_new_record
        assigns[:article].author.should == @user
      end
    end
    
    context "#update" do
      it "updates the article" do
        sign_in @user
        put :update, :governor_mapping => :articles, :id => @article.id, :article => {:title => 'I am awesome, you are awesome'}
        assigns[:article].title.should == 'I am awesome, you are awesome'
      end
    end
    
    context "#destroy" do
      it "deletes the article" do
        sign_in @user
        delete :destroy, :governor_mapping => :articles, :id => @article.id
        assigns[:article].should == @article
        assigns[:article].should be_destroyed
        ::Article.count.should == 0
      end
    end
  end
end
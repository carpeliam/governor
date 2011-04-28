require 'spec_helper'

module Governor
  describe ArticlesController do
    include Devise::TestHelpers
    
    context "which has a plugin with a registered mime response" do
      # not sure how to add something before the controller is loaded, so I
      # added an initializer which adds a plugin that registers a type. See
      # 'governor_testing' in the rails_app/config/initializers directory:
      #
      #     plugin = Governor::Plugin.new('xml support')
      #     plugin.responds_to :xml, :only => [:index]
      #     Governor::PluginManager.register plugin
      #
      render_views
      it "responds to standard html" do
        get :index, :governor_mapping => :articles
        assigns[:articles].should == [@article]
        response.status.should == 200 # :success
      end
      it "doesn't respond to JSON" do
        get :index, :governor_mapping => :articles, :format => :json
        response.status.should == 406 # :not_acceptable
      end
      it "responds to index.xml because the plugin added it" do
        get :index, :governor_mapping => :articles, :format => :xml
        assigns[:articles].should == [@article]
        response.status.should == 200 # :success
        response.body.should =~ /It worked/
      end
      it "doesn't respond to show.xml" do
        get :show, :governor_mapping => :articles, :id => @article.id, :format => :xml
        response.status.should == 406 # :not_acceptable
      end
    end
    
    before(:each) do
      @user = Factory(:user)
      @article = Factory(:article, :author => @user)
    end
    context "#index" do
      it "renders the articles page" do
        get :index, :governor_mapping => :articles
        assigns[:articles].should == [@article]
        response.should render_template(:index)
      end
    end
    
    context "#new" do
      context "when signed out" do
        it "redirects back to the front page" do
          get :new, :governor_mapping => :articles
          response.should redirect_to(root_path)
        end
      end
      
      context "when signed in" do
        before(:each) { sign_in @user }
        
        it "renders the new article page" do
          get :new, :governor_mapping => :articles
          assigns[:article].should be_a ::Article
          assigns[:article].attributes.should == ::Article.new.attributes
          response.should render_template(:new)
        end
      end
    end
    
    context "#show" do
      it "renders the right article" do
        get :show, :governor_mapping => :articles, :id => @article.id
        assigns[:article].should == @article
        response.should render_template(:show)
      end
    end
    
    context "#edit" do
      context "when signed out" do
        it "redirects back to the front page" do
          get :edit, :governor_mapping => :articles, :id => @article.id
          response.should redirect_to(root_path)
        end
      end
      
      context "when signed in" do
        before(:each) { sign_in @user }
        it "renders the edit page" do
          get :edit, :governor_mapping => :articles, :id => @article.id
          assigns[:article].should == @article
          response.should render_template(:edit)
        end
      end
    end
    
    context "#create" do
      context "when signed out" do
        it "redirects back to the front page" do
          post :create, :governor_mapping => :articles
          response.should redirect_to(root_path)
        end
      end
      
      context "when signed in" do
        before(:each) { sign_in @user }
        it "creates a new article and redirects to its page" do
          post :create, :governor_mapping => :articles, :article => {:title => 'Want a job?', :post => 'I accept checks'}
          assigns[:article].should be_a ::Article
          assigns[:article].should_not be_a_new_record
          assigns[:article].author.should == @user
          response.should redirect_to(assigns[:article])
          flash[:notice].should == 'Article was successfully created.'
        end
      end
    end
    
    context "#update" do
      context "when signed out" do
        it "redirects back to the front page" do
          put :update, :governor_mapping => :articles, :id => @article.id, :article => {:title => 'I am awesome, you are awesome'}
          response.should redirect_to(root_path)
        end
      end
      
      context "when signed in" do
        before(:each) { sign_in @user }
        it "updates the article" do
          put :update, :governor_mapping => :articles, :id => @article.id, :article => {:title => 'I am awesome, you are awesome'}
          assigns[:article].title.should == 'I am awesome, you are awesome'
          flash[:notice].should == 'Article was successfully updated.'
        end
      end
    end
    
    context "#destroy" do
      context "when signed out" do
        it "redirects back to the front page" do
          delete :destroy, :governor_mapping => :articles, :id => @article.id
          response.should redirect_to(root_path)
        end
      end
      
      context "when signed in" do
        before(:each) { sign_in @user }
        it "deletes the article" do
          delete :destroy, :governor_mapping => :articles, :id => @article.id
          assigns[:article].should == @article
          assigns[:article].should be_destroyed
          ::Article.count.should == 0
          response.should redirect_to(articles_path)
          flash[:notice].should == 'Article was successfully deleted.'
        end
      end
    end
  end
end
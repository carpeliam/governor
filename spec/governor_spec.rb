require 'spec_helper'

class FakeArticle < ActiveRecord::Base
  establish_connection 'nulldb'
  include Governor::Article
  def author
    'Rod'
  end
end

# we're going to need 'self' later
GOVERNOR_SPEC = self

describe Governor do
  context "authorization" do
    
    %w(new create).each do |action|
      it "should make sure a user is logged in when going to the #{action} page" do
        GOVERNOR_SPEC.expects(:user_signed_in?).returns false
        Governor.authorized?(nil, action).should be_false
        GOVERNOR_SPEC.expects(:user_signed_in?).returns true
        Governor.authorized?(nil, action).should be_true
      end
    end
    
    %w(edit update destroy).each do |action|
      it "should make sure the current user is the author when going to the #{action} page" do
        article = FakeArticle.new
        GOVERNOR_SPEC.expects(:current_user).returns('milorad')
        Governor.authorized?(article, action).should be_false
        GOVERNOR_SPEC.expects(:current_user).returns('Rod')
        Governor.authorized?(article, action).should be_true
      end
    end
    
    it "should raise an exception if any other action is requested" do
      lambda{Governor.authorized(nil, 'who knows what this is')}.should raise_error
    end
  end
end
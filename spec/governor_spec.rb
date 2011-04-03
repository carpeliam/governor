require 'spec_helper'

class FakeArticle < ActiveRecord::Base
  establish_connection 'nulldb'
  include Governor::Article
  def author
    'Rod'
  end
end

describe Governor do
  context "authorization" do
    
    %w(new create).each do |action|
      it "should make sure a user is logged in when going to the #{action} page" do
        self.expects(:user_signed_in?).returns false
        instance_exec(action, &Governor.authorization_rules).should be_false
        self.expects(:user_signed_in?).returns true
        instance_exec(action, &Governor.authorization_rules).should be_true
      end
    end
    
    %w(edit update destroy).each do |action|
      it "should make sure the current user is the author when going to the #{action} page" do
        article = FakeArticle.new
        self.expects(:current_user).returns('milorad')
        instance_exec(action, article, &Governor.authorization_rules).should be_false
        self.expects(:current_user).returns('Rod')
        instance_exec(action, article, &Governor.authorization_rules).should be_true
      end
    end
    
    it "should raise an exception if any other action is requested" do
      lambda{instance_exec('some other action', &Governor.authorization_rules)}.should raise_error
    end
  end
end
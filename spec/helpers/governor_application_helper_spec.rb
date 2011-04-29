require 'spec_helper'

describe GovernorApplicationHelper do
  describe "#governor_header" do
    it "includes a link to a new article" do
      governor_header.should have_selector('a', :href => new_article_path, :content => "New Article")
    end
    it "includes a link to all articles" do
      governor_header.should have_selector('a', :href => articles_path, :content => "Article")
    end
  end
end
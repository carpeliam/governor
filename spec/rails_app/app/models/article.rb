class Article < ActiveRecord::Base
  include Governor::Article
  cattr_reader :per_page
  @@per_page = 10
end
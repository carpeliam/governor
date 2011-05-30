require 'spec_helper'

class ArticleStub < ActiveRecord::Base
  establish_connection 'nulldb'
  include Governor::Article
end

module Governor
  describe Article do
    # find_all_by_date(year, month = nil, day = nil, page = 1)
    context "#time_delta" do
      it "should span a whole year when that's all I ask for" do
        time = Time.parse('2010-01-01')
        ArticleStub.time_delta(2010).should == [time, time.end_of_year]
      end
      
      it "should span a month when that's specified" do
        time = Time.parse('2010-08-01')
        ArticleStub.time_delta(2010, 8).should == [time, time.end_of_month]
      end
      
      it "should span a single day when that's specified" do
        time = Time.parse('2010-08-17')
        ArticleStub.time_delta(2010, 8, 17).should == [time, time.end_of_day]
      end
    end
  end
end

module Governor
  # Include this module into any class that will represent a blog article
  # post.
  module Article
    def self.included(base) #:nodoc:
      base.belongs_to :author, :polymorphic => true
      base.validates_presence_of :author, :title, :post
      
      if defined?(WillPaginate)
        base.cattr_reader :per_page
        base.class_eval "@@per_page = 10"
      end
      
      Governor::PluginManager.plugins.each do |plugin|
        plugin.include_in_model(base)
      end
      
      # Will retrieve all of the articles with a given year, month, or day. If
      # day is not specified, it will find all of the posts for a given month;
      # if month is not specified, then it will find all of the posts for a
      # given year. Specifying a page will work with will_paginate.
      def base.find_all_by_date(year, month = nil, day = nil, page = 1)
        from, to = self.time_delta(year, month, day)
        conditions = ['created_at BETWEEN ? AND ?', from, to]
        if model_class.respond_to?(:paginate)
          paginate :page => page, :conditions => conditions, :order => 'created_at DESC'
        else
          all :conditions => conditions, :order => 'created_at DESC'
        end
      end

      private
      def base.time_delta(year, month = nil, day = nil)
        from = Time.mktime(year, month || 1, day || 1)
        to = if day.present?
          from.end_of_day
        elsif month.present?
          from.end_of_month
        else
          from.end_of_year
        end
        [from, to]
      end
    end
    
    def to_s
      title
    end
  end
end

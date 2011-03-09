module Governor
  module Article
    def self.included(base)
      def base.find_all_by_date(year, month = nil, day = nil, page = 1)
        from, to = self.time_delta(year, month, day)
        conditions = ['created_at BETWEEN ? AND ?', from, to]
        paginate :page => page, :conditions => conditions, :order => 'created_at DESC'
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
  end
end

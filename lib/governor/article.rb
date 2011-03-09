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
        if day.present?
          to = from.end_of_day
        elsif month.present?
          to = from.end_of_month
        else
          to = from.end_of_year
        end
        # to -= 1 # pull off 1 second so we don't overlap onto the next day
        [from, to]
        # 
        # to = from.next_year
        # to = from.next_month unless month.blank?
        # to = from + 1.day unless day.blank?
        # to = to - 1 # pull off 1 second so we don't overlap onto the next day
        # return [from, to]
      end
    end
  end
end

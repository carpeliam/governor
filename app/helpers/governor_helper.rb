module GovernorHelper
  def render_plugin_partial(where, options = {})
    output = ''
    partials = Governor::ViewManager.flashes.delete(where) || []
    partials |= Governor::PluginManager.plugins.map{|p| p.partial_for(where) }.compact
    partials.each do |partial|
      opts = options.merge( {:partial => "governor/#{partial}"} )
      output << render(opts)
    end
    return output.html_safe
  end
  
  def get_date_label(year, month=nil, day=nil)
    l Date.new(*[year, month, day].compact), :format => "#{'%B ' if month}#{'%d, ' if day}%Y"
  end

  def show_time_ago(date)
    %{<time pubdate="" datetime="#{date.localtime.iso8601}" title="#{l date}">#{distance_of_time_in_words_to_now date} ago</time>}.html_safe
  end
end

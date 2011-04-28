module GovernorHelper
  Governor::PluginManager.plugins.map{|p| p.helpers }.flatten.each do |mod|
    include mod.constantize # FIXME this feels pretty dirty, there has to be a better way
  end
  
  def render_plugin_partial(where, options = {})
    output = ''
    Governor::PluginManager.plugins.map{|p| p.partial_for(where) }.compact.each do |partial|
      opts = options.merge( {:partial => "governor/#{partial}"} )
      output << render(opts)
    end
    return output.html_safe
  end
  
  def get_date_label(year, month=nil, day=nil)
    l Date.new(*[year, month, day].compact), :format => "#{'%B ' if month}#{'%d, ' if day}%Y"
  end

  def show_time_ago(date)
    %{<acronym title="#{date.strftime '%A, %B %d, %Y at %I:%M %p'}">#{distance_of_time_in_words_to_now date}</acronym> ago}.html_safe
  end
end

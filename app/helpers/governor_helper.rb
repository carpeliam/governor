module GovernorHelper
  @@months = %w(January February March April May June July August September October November December)
  
  def render_plugin_partial(where, options = {})
    output = ""
    Governor::PluginManager.view_hooks[where].each do |f|
      opts = options.merge( {:file => f} )
      output << render(opts)
    end
    return output
  end
  
  def get_date_label
    if not params[:day].nil?
      "#{@@months[params[:month].to_i - 1]} #{params[:day]}, #{params[:year]}"
    elsif not params[:month].nil?
      "#{@@months[params[:month].to_i - 1]} #{params[:year]}"
    else
      params[:year]
    end
  end

  def show_time_ago(date)
    %{<acronym title="#{date.strftime '%A, %B %d, %Y at %I:%M %p'}">#{distance_of_time_in_words_to_now date}</acronym> ago}.html_safe
  end
end

module GovernorHelper
  def render_plugin_partial(where, options = {})
    output = ""
    Governor::PluginManager.view_hooks[where].each do |f|
      opts = options.merge( {:file => f} )
      output << render(opts)
    end
    return output
  end
end

module GovernorApplicationHelper
  # A navigation header for allowing an administrator to access
  # Governor-related links. By default, it includes a link to all articles and
  # a link to create a new article.
  #
  # The default separator between items is |, which can be customized to be a
  # bullet, an image, or any other string. If you're using Governor with
  # multiple resources, you'll want to specify which one as the second
  # argument. It defaults to the first resource registered.
  def governor_header(separator = '|', resource = Governor.default_resource.plural)
    mapping = Governor.resources[resource.to_sym]
    content_tag :div, :class => 'governor_header' do
      concat(link_to t('governor.all_articles', :resource_type => mapping.humanize.pluralize), send("#{mapping.plural}_path"))
      concat(" #{separator} ".html_safe)
      concat(link_to t('governor.new_article', :resource_type => mapping.humanize), send("new_#{mapping.singular}_path"))
      Governor::PluginManager.plugins.map{|p| p.navigation_hook }.each do |hook|
        if hook.present?
          concat(" #{separator} ".html_safe)
          instance_exec(resource, &hook)
        end
      end
    end
  end
end
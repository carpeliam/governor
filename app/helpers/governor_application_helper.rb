module GovernorApplicationHelper
  def governor_header(resource = Governor.default_resource.plural)
    mapping = Governor.resources[resource.to_sym]
    content_tag :div, :class => 'governor_header' do
      concat(link_to mapping.humanize.pluralize, send("#{mapping.plural}_path"))
      concat(' | ')
      concat(link_to "New #{mapping.humanize}", send("new_#{mapping.singular}_path"))
    end
  end
end
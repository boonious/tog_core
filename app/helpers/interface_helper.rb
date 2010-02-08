module InterfaceHelper
  
  def render_flash_messages
    flash.collect{|entry|
      content_tag(:div, entry[1], :class => "notice #{entry[0]}")
    }
  end
  
  def current_url?(options)
    url = case
    when Hash
      url_for options
    else
      options.to_s
    end
    request.request_uri =~ Regexp.new('^' + Regexp.quote(clean(url)))
  end
  
  def links_for_navigation(section)
    tabs = Tog::Interface.sections(section).tabs
    last_tab_index = tabs.length - 1
    links = tabs.map do |tab|
      if tabs.index(tab) == last_tab_index
        nav_link_to_last(tab)
      else
        nav_link_to(tab)
      end
    end.compact
  end
  
  def nav_link_to(tab)
    if tab.include_url?(request.request_uri)
      content_tag(:li, %{#{link_to I18n.t(tab.key), tab.url}#{sub_nav_links_to(tab.items)}}, :class=>"on")
    else
      content_tag(:li, link_to(I18n.t(tab.key), tab.url))
    end
  end
  
  def nav_link_to_last(tab)
    if tab.include_url?(request.request_uri)
      content_tag(:li, %{#{link_to I18n.t(tab.key), tab.url}#{sub_nav_links_to(tab.items)}}, :class=>"on last")
    else
      content_tag(:li, link_to(I18n.t(tab.key), tab.url), :class=>"last")
    end
  end
  
  def sub_nav_links_to(tabs)
    unless tabs.empty?
      content_tag :ul do
        tabs.collect do |t|
          %{<li#{" class=\"on\"" if current_url?(t[1])}>#{ link_to I18n.t(t[0]), t[1]}</li>}
        end
      end
    end
  end
  
  def columns_distribution
    @columns_distribution || "col_60_40"
  end
end
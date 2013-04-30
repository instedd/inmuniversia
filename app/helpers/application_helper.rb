module ApplicationHelper

  def body_tag
    attrs = case @body_class
      when 'public-content'
        {'data-spy' => 'scroll', 'data-target' => '#sections-bar', 'data-offset' => 120}
      else
        {'class' => @body_class}
      end
    
    content_tag :body, attrs do
      yield
    end
  end

  def nav_link(text, path, *controllers)
    klazz = controllers.include?(params[:controller]) ? "active" : ""
    content_tag :li, :class => klazz do
      link_to text, path
    end
  end

  def tab_pane(opts={})
    active = opts.delete(:active)
    opts[:class] ||= "" 
    opts[:class] << ' active in' if active
    opts[:class] << ' tab-pane'
    
    content_tag :div, opts do
      yield
    end
  end

  def tab_button(text, target, opts={})
    active = opts.delete(:active)
    opts[:href] = "##{target}"
    opts[:'data-toggle'] = "tab"
    opts[:'data-tab-name'] = target
    opts[:class] ||= "" 
    opts[:class] << ' active' if active
    opts[:class] << ' btn'
    
    content_tag :button, text, opts
  end

end

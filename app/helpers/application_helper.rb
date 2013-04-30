module ApplicationHelper

  def body_tag
    attrs = case @body_class
      when 'public-content'
        {'data-spy' => 'scroll', 'data-target' => '#sections-bar', 'data-offset' => 120}
      else
        Hash.new 
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

end

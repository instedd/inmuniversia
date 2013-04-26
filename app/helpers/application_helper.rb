module ApplicationHelper

  def nav_link(text, path, *controllers)
    klazz = controllers.include?(params[:controller]) ? "active" : ""
    content_tag :li, :class => klazz do
      link_to text, path
    end
  end

end

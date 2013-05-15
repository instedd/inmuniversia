module PublicContentHelper

  def section(label, name, object)
    (content_tag :section, id: name, name: name do
      content_tag(:h1, label) + object.send(name).try(:html_safe)
    end) + content_tag(:hr)
  end

end
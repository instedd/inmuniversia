module ChildrenHelper

  def render_new_child_form(child=nil)
    child ||= Child.new
    render 'children/form', child: child
  end

end

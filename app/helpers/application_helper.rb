# Copyright (C) 2013, InSTEDD
#
# This file is part of Inmuniversia.
#
# Inmuniversia is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Inmuniversia is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Inmuniversia.  If not, see <http://www.gnu.org/licenses/>.

module ApplicationHelper

  def body_tag
    attrs = case @body_class
      when 'public-content'
        {'data-spy' => 'scroll', 'data-target' => '#sections-bar', 'data-offset' => 210}
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
    opts[:href] = "##{target}"
    opts[:'data-tab-name'] = target
    opts[:'data-toggle'] = "tab"

    opts[:class] ||= ""
    opts[:class] << ' active' if opts.delete(:active)
    opts[:class] << ' btn'

    content_tag :button, text, opts
  end

  def nodisplay_if(condition)
    if condition
      {class: 'nodisplay'}
    else
      {}
    end
  end

end

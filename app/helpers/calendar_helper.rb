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

module CalendarHelper

  def calendar_timespan_td(timespan, method, opts={}, &block)
    text = timespan.send(method) unless timespan.empty?
    opts[:class] ||= ''
    opts[:class] << ' selected' if timespan.current?
    opts[:class] << ' empty' if timespan.empty?
    content_tag :td, text, opts, &block
  end

  def calendar_vaccination_td(*args)
    opts = args.extract_options!
    vaccination = opts.delete(:vaccination)

    opts[:class] ||= ''
    opts[:class] << ' selected' if opts.delete(:selected)
    opts[:class] << ' empty' if opts.delete(:empty)
    
    opts[:id] = "calendar-vaccination-#{vaccination.id}" if vaccination
    
    content_tag *([:td] + args + [opts]) do
      calendar_vaccination_entry(vaccination) if vaccination
    end
  end

  def calendar_vaccination_entry(vaccination)
    content_tag :div, class: "calendar-entry #{vaccination.status.to_s}" do
      content_tag :i, "", vaccination.to_data_hash.merge(class: 'calendar-vaccination')
    end
  end

end
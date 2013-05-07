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
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

    if vaccination
      opts[:class] << ' ' << vaccination.status.to_s
      opts[:id] = "calendar-vaccination-#{vaccination.id}"
    end

    content_tag *([:td] + args + [opts]) do
      if vaccination
        content_tag :i, "", vaccination.to_data_hash.merge(class: 'calendar-vaccination')
      end
    end
  end

end
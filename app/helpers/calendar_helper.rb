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
    opts[:class] ||= ''
    opts[:class] << ' selected' if opts[:selected]
    opts[:class] << ' empty' if opts[:empty]
    opts[:class] << ' ' << opts[:vaccination].status.to_s if opts[:vaccination]
    opts[:id] = "calendar-vaccination-#{opts[:vaccination].id}" if opts[:vaccination]

    content_tag *([:td] + args + [opts]) do
      if opts[:vaccination]
        content_tag :i, "", class: 'calendar-vaccination', id: "calendar-vaccination-#{opts[:vaccination].id}"
      end
    end
  end

end
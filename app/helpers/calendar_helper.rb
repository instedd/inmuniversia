module CalendarHelper

  def calendar_timespan_td(timespan, method, opts={}, &block)
    text = timespan.send(method) unless timespan.empty?
    opts[:class] ||= ''
    opts[:class] << ' selected' if timespan.current?
    opts[:class] << ' empty' if timespan.empty?
    content_tag :td, text, opts, &block
  end

  def calendar_vaccination_td(*args, &block)
    opts = args.extract_options!
    opts[:class] ||= ''
    opts[:class] << ' selected' if opts[:selected]
    opts[:class] << ' empty' if opts[:empty]
    opts[:class] << ' ' << opts[:vaccination].status.to_s if opts[:vaccination]
    content_tag *([:td] + args + [opts]), &block
  end

end
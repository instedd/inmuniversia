module ChannelsHelper

  def render_channels(subscriber, type)
    channels = subscriber.send("#{type}_channels")
    channels = channels.presence || [channels.send(type).build]
    safe_join channels.map{ |c| render c }
  end

end

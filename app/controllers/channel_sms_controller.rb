class ChannelSmsController < AuthenticatedController

  before_filter :load_channel, only: [:update]

  def update
    @channel.update_attributes(params[:channel_sms])
    render @channel
  end

  protected

  def load_channel
    @channel = current_subscriber.sms_channels.find(params[:id])
  end

end

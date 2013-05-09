class ChannelEmailsController < AuthenticatedController

  before_filter :load_channel, only: [:update, :destroy]

  def create
    @channel = current_subscriber.email_channels.new(params[:channel_email])
    @channel.save
    render @channel
  end

  def update
    @channel.update_attributes(params[:channel_email])
    render @channel
  end

  def destroy
    @channel.destroy
    render nothing: true
  end

  protected

  def load_channel
    @channel = current_subscriber.email_channels.find(params[:id])
  end

end

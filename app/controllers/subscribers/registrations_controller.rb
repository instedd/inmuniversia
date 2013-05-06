class Subscribers::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    subscribers_mobile_configuration_path
  end
  # def after_sign_in_path_for(resource)
  #   dashboard_path
  # end

  def mobile_configuration
    @email = current_subscriber.email
    @channel = Channel::Sms.new
  end

  def add_mobile_number_and_send_verification_code channel=nil
    @error
    @resend = false
    @error = false
    if channel
      @channel = channel
      @error = true
    else
      if params[:channel_sms_resend]
        @channel = Channel.find(params[:channel_sms_resend])
        @resend = true
      else
        @channel = current_subscriber.sms_channels.new(:address => params[:channel_sms][:address])
      end
    end

    @channel.send_verification_code

    if @channel.save
      # puts "Salvado correctamente"

    else
      flash[:notice] = @channel.errors.messages[:address][0]
      redirect_to subscribers_mobile_configuration_url()
    end

  end

  def submit_verification_code
    if params[:id] == ""
      redirect_to root_url
    else
      @channel = Channel.find(params[:id])

      if (@channel.verification_code == params[:verification_code][0])
        flash[:notice] = "El celular ha sido agregado correctamente"
        redirect_to dashboard_path
      else
        @error = true
        render "add_mobile_number_and_send_verification_code"
      end
    end
  end
end
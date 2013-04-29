class Subscribers::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    subscribers_mobile_configuration_path
  end
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def mobile_configuration
    @errors = params[:errors]
    flash[:notice] = @errors
    @email = current_subscriber.email
    @channel = Channel::Sms.new
  end

  def add_mobile_number_and_send_verification_code
    @channel = current_subscriber.sms_channels.new(:address => params[:channel_sms][:address])

    @channel.send_verification_code

    if @channel.save
      # puts "Salvado correctamente"
    else
      # Manejar mejor este caso
      redirect_to subscribers_mobile_configuration_url(:errors => "#{@channel.errors.messages[:address][0]}")
    end

  end

  def submit_verification_code
    if params[:id] == ""
      redirect_to root_url
    else
      @channel = Channel.find(params[:id])

      if (@channel.verification_code == params[:verification_code][0])
        render "mobile_number_success"
      else
        render "mobile_number_error"
      end
    end
  end
end
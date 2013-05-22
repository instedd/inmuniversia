class Subscribers::RegistrationsController < Devise::RegistrationsController

  # prepend_before_filter :authenticate_subscriber!, force: true

  def after_sign_up_path_for(resource)
    subscribers_mobile_configuration_path
  end

  def subscriber_from_mobile
    @channel = Channel::Sms.new
  end

  def find_subscriber_and_send_verification_code
    @error
    @resend = false
    @error = false
    if params[:channel_sms_resend]
      @channel = Channel::Sms.find(params[:channel_sms_resend])
      @resend = true
    else
      @channel = Channel::Sms.find_by_address(params[:channel_sms][:address])
      # @channel = current_subscriber.sms_channels.new(:address => params[:channel_sms][:address])
    end

    if @channel && @channel.save
      if @channel.subscriber.sms_only
        @channel.send_verification_code
        @channel.save
      else
        #  Por alguna razon los errors no estan andando. Por ahora dejo los notices
        #flash[:error] = "Ya existe un usuario web con ese numero. Por favor intente loguearse con el mismo."
        flash[:notice] = "Ya existe un usuario web con ese numero. Por favor intente loguearse con el mismo."
        redirect_to root_path
      end
    else
      # flash[:error] = "No se encontro un usuario registrado con ese numero. Intentelo de nuevo"
      flash[:notice] = "No se encontro un usuario registrado con ese numero. Intentelo de nuevo"
      redirect_to subscribers_subscriber_from_mobile_url()
    end
  end

  def update_sms_user
    subscriber_hash = params[:subscriber]
    subscriber_hash["sms_only"] = false
    subscriber = Subscriber.where(:id => subscriber_hash[:id]).first

    if subscriber && subscriber.sms_only
      subscriber.attributes = subscriber_hash.except("id")
      subscriber.build_email_channel
      subscriber.save

      sign_in_and_redirect(subscriber)
    else
      # No se deberia llegar a este caso
      # flash[:error] = "Hubo un problema. Intentelo de nuevo"
      flash[:notice] = "Hubo un problema. Intentelo de nuevo"
      redirect_to root_path
    end
  end

  def submit_verification_code_and_fulfill_user_data
    if params[:id] == ""
      redirect_to root_url
    else
      @channel = Channel::Sms.find(params[:id])
      if (@channel.verification_code == params[:verification_code][0])
        @channel.verification_code = nil
        @channel.save!
        @subscriber = @channel.subscriber
      else
        @error = true
        render "find_subscriber_and_send_verification_code"
      end
    end
  end

  def mobile_configuration
    # authenticate_subscriber!
    @email = current_subscriber.email
    @channel = Channel::Sms.new
  end

  def add_mobile_number_and_send_verification_code channel=nil
    @error
    @resend = false
    @error = false
    if params[:channel_sms_resend]
      @channel = Channel::Sms.find(params[:channel_sms_resend])
      @resend = true
    else
      @channel = current_subscriber.sms_channels.new(:address => params[:channel_sms][:address])
    end

    if @channel.save
      @channel.send_verification_code
      @channel.save
    else
      flash[:notice] = @channel.errors.messages[:address][0]
      redirect_to subscribers_mobile_configuration_url()
    end
  end

  def submit_verification_code
    if params[:id] == ""
      redirect_to root_url
    else
      @channel = Channel::Sms.find(params[:id])
      if (@channel.verification_code == params[:verification_code][0])
        @channel.verification_code = nil
        @channel.save!
        flash[:notice] = "El celular ha sido agregado correctamente"
        redirect_to dashboard_path
      else
        @error = true
        render "add_mobile_number_and_send_verification_code"
      end
    end
  end
end
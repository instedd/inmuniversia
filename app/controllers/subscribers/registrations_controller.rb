# encoding: UTF-8
class Subscribers::RegistrationsController < Devise::RegistrationsController

  # prepend_before_filter :authenticate_subscriber!, force: true

  def after_sign_up_path_for(resource)
    subscribers_mobile_configuration_path
  end

  def subscriber_from_mobile
    @channel = Channel::Sms.new
  end

  def edit
    @subscriber = current_subscriber
  end

  def update
    if params[:subscriber][:password].blank?
      params[:subscriber].delete("password")
      params[:subscriber].delete("password_confirmation")
    end
    subscriber = current_subscriber

    if current_subscriber.id == params[:subscriber][:id].to_i && current_subscriber.update_attributes(params[:subscriber].except("id"))
      sign_in(subscriber, :bypass => true) if params[:subscriber][:password]
      flash[:notice] = "Sus datos se han actualizado correctamente"
      redirect_to root_path
    else
      render "edit"
    end
  end

  # Update sms subscriber
  def find_subscriber_and_send_verification_code
    @resend = false
    if params[:channel_sms_resend]
      @channel = Channel::Sms.find(params[:channel_sms_resend])
      @resend = true
    else
      @channel = Channel::Sms.find_by_address(params[:channel_sms][:address])
    end

    if @channel
      if @channel.subscriber.sms_only
        @channel.send_verification_code
        @channel.save
      else
        begin
          splitted_email = @channel.subscriber.email.split("@")
          hidden_email = "#{splitted_email[0][0]}xxxxx#{splitted_email[0][-1]}@#{splitted_email[1]}"
          flash[:alert] = "Ya existe un usuario creado en la web con ese numero, con email #{hidden_email}. Por favor intente ingresar con el mismo."
        rescue
          flash[:alert] = "Ya existe un usuario creado en la web con ese numero. Por favor intente ingresar con el mismo."
        end
        redirect_to root_path
      end
    else
      flash[:alert] = "No se encontro un usuario registrado con ese numero. Intentelo de nuevo"
      redirect_to subscribers_subscriber_from_mobile_url()
    end
  end

  def submit_verification_code_and_fulfill_user_data
    if !params[:id] || params[:id] == ""
      redirect_to root_url
    else
      @channel = Channel::Sms.find(params[:id])
      if @channel.verify params[:verification_code][0]
        @subscriber = @channel.subscriber
      else
        @error = true
        render "find_subscriber_and_send_verification_code"
      end
    end
  end

  def update_sms_user
    subscriber_hash = params[:subscriber]
    subscriber_hash["sms_only"] = false
    subscriber = Subscriber.where(:id => subscriber_hash[:id]).first

    if subscriber && subscriber.sms_only
      if subscriber.update_attributes subscriber_hash.except("id")
        subscriber.build_email_channel
        subscriber.save

        sign_in_and_redirect(subscriber)
      else
        @subscriber = subscriber
        render "submit_verification_code_and_fulfill_user_data"
      end
    else
      # No se deberia llegar a este caso
      flash[:alert] = "Hubo un problema. Intentelo de nuevo"
      redirect_to root_path
    end
  end

  # Create subscriber
  def mobile_configuration
    # authenticate_subscriber!
    @email = current_subscriber.email
    @from_dashboard = params.get_bool :from_dashboard
    @channel = Channel::Sms.new
  end

  def add_mobile_number_and_send_verification_code channel=nil
    @error
    @resend = false
    @error = false
    @from_dashboard = false
    if params[:channel_sms]
      params[:channel_sms].get_bool :from_dashboard
    end
    if params[:channel_sms_resend]
      @channel = Channel::Sms.find(params[:channel_sms_resend])
      @resend = true
    else
      @channel = current_subscriber.sms_channels.new(:address => params[:channel_sms][:address])
    end

    # Check if there is already a subscriber registered with this cellphone
    if old_channel = Channel::Sms.where(:address => @channel.address, :verification_code => "verified").first
      old_subscriber = old_channel.subscriber
      if old_subscriber.sms_only
        @old_sms_subscriber_id = old_subscriber.id
      else
        flash[:alert] = "Encontramos que existe un usuario en la web con ese número. Intente loguearse con el mismo, o ingrese otro número de celular."
        redirect_to subscribers_mobile_configuration_url() and return
      end
    end

    if @channel.save
      @channel.send_verification_code
      @channel.save
    else
      flash[:alert] = @channel.errors.messages[:address][0]
      redirect_to subscribers_mobile_configuration_url()
    end
  end

  def submit_verification_code
    if params[:id] == ""
      redirect_to root_url
    else
      @channel = Channel::Sms.find(params[:id])
      if @channel.verification_code == params[:verification_code][0]
        if params[:old_sms_subscriber_id] && params[:old_sms_subscriber_id] != ""
          old_subscriber = Subscriber.find(params[:old_sms_subscriber_id])
          if old_subscriber.sms_only && old_subscriber.sms_channels.first.address == @channel.address
            if params[:answer] == 'true'
              new_subscriber = @channel.subscriber
              new_subscriber.children = old_subscriber.children
              new_subscriber.save!
              old_subscriber.destroy
            else
              old_subscriber.sms_channels.first.destroy
            end
          else
            #puts "alguien toco el request"
          end
        end
        if @channel.verify params[:verification_code][0]
          flash[:notice] = "El celular ha sido agregado correctamente"
          redirect_to dashboard_path
        end
      else
        @from_dashboard = params[:from_dashboard]
        @error = true
        render "add_mobile_number_and_send_verification_code"
      end
    end
  end
end
class SettingsController < AuthenticatedController

  def update_preferences
    current_subscriber.preferences.merge! params[:preferences]
    current_subscriber.save
    render nothing: true
  end

end
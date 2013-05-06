class VaccinationsController < AuthenticatedController

  before_filter :load_vaccination

  def update
    @vaccination.update_attributes params[:vaccination]
    date_format = %w(short long default month_year year).include?(params[:date_format]) ? params[:date_format].to_sym : params[:date_format] || :short
    render partial: "vaccinations/#{params[:render]}_entry", locals: {vaccination: VaccinationPresenter.new(@vaccination), date_format: date_format}
  end

  protected

  def load_vaccination
    @vaccination = current_subscriber.vaccinations.find(params[:id])
  end
  
end
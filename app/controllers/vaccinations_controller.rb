class VaccinationsController < AuthenticatedController

  before_filter :load_vaccination

  def update
    @vaccination.update_attributes params[:vaccination]
    render partial: "vaccinations/#{params[:render]}_entry", locals: {vaccination: VaccinationPresenter.new(@vaccination), date_format: params[:date_format] || :short}
  end

  protected

  def load_vaccination
    @vaccination = current_subscriber.vaccinations.find(params[:id])
  end
  
end
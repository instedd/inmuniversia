module VaccinationHelper

  def render_vaccination_status(vaccination)
    render 'shared/vaccination_status_dropdown', vaccination: vaccination
  end

end
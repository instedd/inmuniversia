module VaccinationHelper

  def render_vaccination_status(vaccination)
    render 'vaccinations/status_dropdown', vaccination: vaccination
  end

  def render_agenda_entry(vaccination, opts)
    section = opts[:section]
    render 'vaccinations/agenda_entry', vaccination: vaccination, date_format: section.vaccination_date_format
  end

  def vaccination_status_icon(status)
    content_tag :i, '', class: "st-#{status}"
  end

end
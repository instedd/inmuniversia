class VaccinePresenter < Presenter
  delegate :id, :name, :diseases, to: :@vaccine
  delegate :status, :status_active?, :status_disabled?, to: :@subscription

  def initialize(vaccine, opts={})
    @vaccine = vaccine
    @subscription = opts[:subscription]
  end

  def diseases_list
    diseases.map(&:name).join(", ")
  end

  def subscription_id
    @subscription.id
  end

  def vaccinations
    @vaccinations ||= VaccinationPresenter.present(@subscription.vaccinations)
  end

end
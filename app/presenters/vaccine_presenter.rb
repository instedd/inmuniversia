class VaccinePresenter < Presenter
  delegate :name, :diseases, to: :@vaccine
  delegate :id, :status, :status_active?, :status_disabled?, to: :@subscription

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

  def vaccine_id
    @vaccine.id
  end

  def vaccinations
    @vaccinations ||= VaccinationPresenter.present(@subscription.vaccinations)
  end

  def enabled
    status_active?
  end

  def persisted?
    true
  end

end
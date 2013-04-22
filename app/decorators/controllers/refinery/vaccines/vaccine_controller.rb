Refinery::Vaccines::VaccinesController.class_eval do
  
  def show
    @vaccine = @vaccines.find(params[:id])
    present(@page)
  end

  def find_all_vaccines
    @vaccines = if user_signed_in?
      Vaccine.scoped
    else
      Vaccine.published
    end
  end

end
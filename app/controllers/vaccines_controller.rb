class VaccinesController < ApplicationController

  before_filter :load_vaccines

  layout 'sidebar', only: :show

  def index
  end

  def show
    @vaccine = @vaccines.find(params[:id])
  end

  protected

  def load_vaccines
    @vaccines = if user_signed_in?
      Vaccine.scoped
    else
      Vaccine.published
    end
  end

end
class DiseasesController < ApplicationController

  before_filter :load_diseases

  layout 'sidebar', only: :show

  def index
  end

  def show
    @disease = @diseases.find(params[:id])
  end

  protected

  def load_diseases
    @diseases = if user_signed_in?
      ::Disease.scoped
    else
      ::Disease.published
    end
  end

end
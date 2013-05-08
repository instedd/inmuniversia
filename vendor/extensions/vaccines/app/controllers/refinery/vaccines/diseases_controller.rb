module Refinery
  module Vaccines
    class DiseasesController < ::ApplicationController

      before_filter :find_all_diseases
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @disease in the line below:
        present(@page)
      end

      def show
        @disease = Disease.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @disease in the line below:
        present(@page)
      end

    protected

      def find_all_diseases
        @diseases = Disease.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/diseases").first
      end

    end
  end
end

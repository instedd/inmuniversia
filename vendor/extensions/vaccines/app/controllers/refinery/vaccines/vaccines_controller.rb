module Refinery
  module Vaccines
    class VaccinesController < ::ApplicationController

      before_filter :find_all_vaccines
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @vaccine in the line below:
        present(@page)
      end

      def show
        @vaccine = Vaccine.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @vaccine in the line below:
        present(@page)
      end

    protected

      def find_all_vaccines
        @vaccines = Vaccine.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/vaccines").first
      end

    end
  end
end

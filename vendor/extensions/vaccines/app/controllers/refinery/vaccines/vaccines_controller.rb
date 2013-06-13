# Copyright (C) 2013, InSTEDD
#
# This file is part of Inmuniversia.
#
# Inmuniversia is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Inmuniversia is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Inmuniversia.  If not, see <http://www.gnu.org/licenses/>.

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

module Refinery
  module Vaccines
    module Admin
      class VaccinesController < ::Refinery::AdminController

        crudify :'refinery/vaccines/vaccine',
                :title_attribute => 'name', :xhr_paging => true

      end
    end
  end
end

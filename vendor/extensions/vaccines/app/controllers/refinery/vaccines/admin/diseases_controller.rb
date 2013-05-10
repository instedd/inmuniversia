module Refinery
  module Vaccines
    module Admin
      class DiseasesController < ::Refinery::AdminController

        crudify :'refinery/vaccines/disease',
                :title_attribute => 'name', :xhr_paging => true

      end
    end
  end
end

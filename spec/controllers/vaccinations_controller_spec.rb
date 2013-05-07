require 'spec_helper'

describe VaccinationsController do

  let!(:subscriber) { create(:subscriber) }
  let!(:vaccine)    { create(:vaccine, :with_doses) }
  let!(:child)      { create(:child, :with_setup, parent: subscriber) }

  let(:vaccination) { child.vaccinations.first }

  before(:each) {sign_in subscriber}

  %w(agenda calendar).each do |section|

    it "should update vaccination status from #{section}" do
      vaccination.status.should eq('planned')
      
      xhr :put, :update, id: vaccination.id, vaccination: {status: 'taken'}, render: section
      
      response.should be_successful
      vaccination.reload.status.should eq('taken')
    end

  end

end
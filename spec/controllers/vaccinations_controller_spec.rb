require 'spec_helper'

describe VaccinationsController do

  let!(:subscriber) { create(:subscriber) }
  let!(:vaccine)    { create(:vaccine, :with_doses) }
  let!(:child)      { create(:child, :with_setup, parent: subscriber) }

  let(:vaccination) { child.vaccinations.first }

  before(:each) {sign_in subscriber}

  it "should update vaccination status from agenda" do
    vaccination.status.should eq('planned')
    
    xhr :put, :update, id: vaccination.id, vaccination: {status: 'taken'}, render: 'agenda'
    
    response.should be_successful
    vaccination.reload.status.should eq('taken')
  end

end
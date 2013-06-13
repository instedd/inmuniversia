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
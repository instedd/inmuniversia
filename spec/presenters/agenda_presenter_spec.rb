# coding: UTF-8

require 'spec_helper'

describe AgendaPresenter do

  let(:subscriber)  { create(:subscriber) }
  let(:presenter)   { child; AgendaPresenter.new(subscriber) }  

  before(:each) { Timecop.freeze(Time.utc(2013,5,1,12,0,0)) }

  def expect_section(section, *vaccinations, opts)
    section.title.should eq(opts[:title]) if opts[:title]
    section.date.should eq(opts[:date]) if opts[:date] 
    section.should have(vaccinations.count).vaccinations

    section.vaccinations.each_with_index do |actual_vaccination, index|
      expected_vaccination = vaccinations[index]
      actual_vaccination.date.should be_during(*expected_vaccination[:date])
      actual_vaccination.status.should eq(expected_vaccination[:status])
    end
  end

  context "with single child" do

    let(:child) { create(:child, :with_setup, parent: subscriber, date_of_birth: Date.new(2012,2,15)) }

    context "and multiple vaccines" do
      let!(:yearly_vaccine)  { create(:vaccine, :with_doses, dose_count: 2) }
      let!(:monthly_vaccine) { create(:vaccine, :with_monthly_doses, first_dose_at: 14) }
      let!(:single_vaccine)  { create(:vaccine, :with_monthly_doses, first_dose_at: 22, dose_count: 1) }
      
      it "should generate correct number of sections" do
        presenter.should have(5).sections, 
          "expected 5 sections, but found: #{presenter.sections.map(&:title).join(', ') rescue '[error]'}"
      end

      it "should generate past vaccinations section" do
        expect_section presenter.sections[0],
          {status: 'past', date: [2013, 2]},
          {status: 'past', date: [2013, 4]},
          title: 'Vencidas'
      end

      it "should generate this month vaccinations section" do
        expect_section presenter.sections[1],
          {status: 'planned', date: [2013, 5, 15]},
          title: 'Este mes'
      end

      it "should generate next month vaccinations section" do
        expect_section presenter.sections[2],
          {status: 'planned', date: [2013, 6, 15]},
          title: 'En 1 mes',
          date: 'Junio 2013'
      end

      it "should generate this year vaccinations section for vaccinations in more than six months" do
        expect_section presenter.sections[3],
          {status: 'planned', date: [2013, 12, 15]},
          title: 'Este año',
          date: '2013'
      end

      it "should generate next year vaccinations section" do
        expect_section presenter.sections[4],
          {status: 'planned', date: [2014, 2, 15]},
          title: 'En 1 año',
          date: '2014'
      end
    
    end

  end

end
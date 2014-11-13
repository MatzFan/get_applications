require_relative 'spec_helper'
require './mechanizer'

describe Mechanizer do

  let(:ref) { 'RW/2014/0548' }
  let(:mechanizer) { Mechanizer.new(ref) }
  let(:url) { 'https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&r=' + ref }
  let(:dates) { ['ValidDate|04/04/2014',
       'AdvertisedDate|15/04/2014',
       'endpublicityDate|06/05/2014',
       'SitevisitDate|',
       'CommitteeDate|15/08/2014',
       'Decisiondate|14/10/2014',
       'Appealdate|18/06/2014'] }

  context "#get_details_page" do
    specify "should return the application details page" do
      expect(mechanizer.get_details_page.uri.to_s).to eq(url)
    end
  end

  context "#app_coords" do
    specify "should return the coordinates of the application" do
      expect(mechanizer.app_coords.join).to eq('49.185511-2.191882')
    end
  end

  context "#app_dates" do
    specify "should return the dates for the application" do
      expect(mechanizer.app_dates).to eq(dates)
    end
  end

end

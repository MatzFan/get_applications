require_relative 'spec_helper'
require './mechanizer'

describe Mechanizer do

  let(:ref) { 'RW/2014/0548' }
  let(:mechanizer) { Mechanizer.new(ref) }
  let(:url) { 'https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&r=' + ref }
  let(:coords) { ['Latitude|49.185511', 'Longitude|-2.191882'] }
  let(:details) { ["Reference|RW/2014/0548",
                   "Category|RW",
                   "Status|APPEAL",
                   "Officer|Richard Greig",
                   "Applicant|Mr & Mrs R.I.G. Hardcastle, Le Mont Sohier, St. Brelade, JE3 8EA",
                   "Description|Replace 5 No. windows on South elevation..... REQUEST FOR RECONSIDERATION for refusal of planning permission.",
                   "ApplicationAddress|Homewood",
                   "RoadName|Le Mont Sohier",
                   "Parish|St. Brelade",
                   "PostCode|JE3 8EA",
                   "Constraints|Built-Up Area, Green Backdrop Zone, Potential Listed Building, Primary Route Network",
                   "Agent|",
                   "49.185511", "-2.191882"]}
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
      expect(mechanizer.app_coords).to eq(coords)
    end
  end

  context "#app_dates" do
    specify "should return the dates for the application" do
      expect(mechanizer.app_dates).to eq(dates)
    end
  end

end

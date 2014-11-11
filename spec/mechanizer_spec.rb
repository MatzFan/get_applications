require_relative 'spec_helper'
require './mechanizer'

describe Mechanizer do

  let(:ref) { 'P/2014/1921' }
  let(:mechanizer) { Mechanizer.new(ref) }
  let(:url) { 'https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&r=' + ref }

  context "#get_details_page" do
    specify "should return the application details page" do
      expect(mechanizer.get_details_page.uri.to_s).to eq(url)
    end
  end

  context "#app_coords" do
    specify "should return the coordinates of the application" do
      expect(mechanizer.app_coords.join).to eq('49.195662-2.035281')
    end
  end

end

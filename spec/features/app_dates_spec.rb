require_relative '../spec_helper'

describe 'app_dates path' do
  describe 'GET /app_dates' do
    let(:ref) {'RW/2014/0548'}
    let(:dates) { ['ValidDate|04/04/2014',
                   'AdvertisedDate|15/04/2014',
                   'endpublicityDate|06/05/2014',
                   'SitevisitDate|',
                   'CommitteeDate|15/08/2014',
                   'Decisiondate|14/10/2014',
                   'Appealdate|18/06/2014'].join("\n") }
    before { get '/app_dates', {app_ref: ref} }

    it 'should return the correct dates' do
      expect(last_response.body).to eq(dates)
    end

  end
end

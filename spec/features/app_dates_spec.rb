require_relative '../spec_helper'

describe 'app_dates path' do
  describe 'GET /app_dates' do
    let(:ref) {'RW/2014/0548'}
    let(:dates) {"04/04/2014\n15/04/2014\n06/05/2014\n\n15/08/2014\n14/10/2014\n18/06/2014"}
    before { get '/app_dates', {app_ref: ref} }

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'should return the correct dates' do
      expect(last_response.body).to eq(dates)
    end

  end
end

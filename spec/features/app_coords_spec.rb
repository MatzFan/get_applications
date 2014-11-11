require_relative '../spec_helper'

describe 'app_coords path' do
  describe 'GET /app_coords' do
    let(:ref) {'P/2014/1921'}
    before { get '/app_coords', {app_ref: ref} }

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'should return the correct coords' do
      expect(last_response.body).to eq("49.195662\n-2.035281")
    end

  end
end

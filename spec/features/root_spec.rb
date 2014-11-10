require_relative '../spec_helper'

describe 'Root Path' do
  describe 'GET /' do
    before { get '/' }

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'should return 4 digits as text' do
      expect(last_response).to match(/\d{4}/)
    end

  end
end

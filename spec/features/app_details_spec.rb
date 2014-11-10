require_relative '../spec_helper'

describe 'app_details path' do
  describe 'GET /app_details' do
    let(:ref) {'P/2014/1940'}
    before { get '/app_details', {app_ref: ref} }

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'should return 12 lines of text' do
      expect(last_response.body.split("\n").size).to eq(12)
    end

  end
end

require_relative '../spec_helper'

describe 'app_details path' do
  describe 'GET /app_details' do
    let(:ref) {'P/2014/1940'}
    before { get '/app_details', {app_ref: ref} }

    it 'should return 14 lines of text (last 2 are map coords)' do
      expect(last_response.body.split("\n").size).to eq(14)
    end

  end
end

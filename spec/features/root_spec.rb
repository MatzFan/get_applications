require_relative '../spec_helper'

describe 'Root Path' do
  describe 'GET /' do
    before { get '/' }

    it 'should return 4 digits as text' do
      expect(last_response).to match(/\d{4}/)
    end

  end
end

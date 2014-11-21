require_relative '../spec_helper'

describe 'doc_app_refs path' do
  describe 'GET /doc_app_refs' do
    let(:id) {'108'}
    before { get '/doc_app_refs', {id: id} }

    it 'should return the correct application refs linked to the document' do
      expect(last_response.body).to eq('P/2014/0672')
    end

  end
end

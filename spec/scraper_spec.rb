require './scraper'

describe Scraper do

  # let(:scraper) { Scraper.new(2014) }

  context "#num_apps" do

      specify "should return the number of applications for the specified year" do
        expect(Scraper.new(2013).num_apps).to eq('1448')
      end

  end # of context

end # of describe

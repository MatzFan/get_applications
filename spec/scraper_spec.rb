require './scraper'

describe Scraper do

  let(:scraper) { Scraper.new(2013) }
  let(:app_refs) { 'P/2013/1848|P/2013/1847|P/2013/1846|P/2013/1843|P/2013/' +
    '1842|A/2013/1845|A/2013/1844|RC/2013/1841|P/2013/1840|P/2013/1836' }

  context "#num_apps" do
    specify "should return the number of applications for the specified year" do
      expect(scraper.num_apps).to eq(1448)
    end
  end

  context "#app_refs_on_page" do
    specify "should return an array of the application references on the specified page" do
      expect(scraper.app_refs_on_page(1)).to eq(app_refs)
    end
  end

end # of describe

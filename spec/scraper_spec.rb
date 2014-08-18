require './scraper'

describe Scraper do

  let(:scraper) { Scraper.new(2013) }
  let(:app_refs1) { 'P/2013/1848|P/2013/1847|P/2013/1846|P/2013/1843|P/2013/' +
    '1842|A/2013/1845|A/2013/1844|RC/2013/1841|P/2013/1840|P/2013/1836' }
  let(:app_refs2) { 'P/2013/1835|RP/2013/1833|P/2013/1834|P/2013/1831|RW/' +
    '2013/1826|RP/2013/1828|P/2013/1830|P/2013/1827|P/2013/1825|P/2013/1824' }

  context "#num_apps" do
    specify "should return the number of applications for the given year" do
      expect(scraper.num_apps).to eq(1448)
    end
  end

  context "#app_refs_on_page" do
    specify "should return list of application references on the given page" do
      expect(scraper.app_refs_on_page(1)).to eq(app_refs1)
      expect(scraper.app_refs_on_page(2)).to eq(app_refs2)
      expect(Scraper.new(1987).app_refs_on_page(1)).to eq('P/1987/0038')
    end
  end

  context "#latest_app_num" do
    specify "should return the number of applications for the given year" do
      expect(scraper.latest_app_num).to eq(1848)
    end
  end


end # of describe

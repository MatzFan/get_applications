require_relative 'spec_helper'
require './doc_scraper'

describe DocScraper do

  let(:scraper) { DocScraper.new }

  context "#initialize" do
    specify "should return a DocScraper object" do
      expect(scraper.class).to eq(DocScraper)
    end
  end

  context "#page_source" do
    specify "should return the agendas/minutes page source" do
      expect(scraper.page_source.title).to include('Agendas and minutes')
    end
  end

end

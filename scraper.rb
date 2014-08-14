require 'watir'
require 'phantomjs'

class Scraper

  URL = 'https://www.mygov.je/Planning/Pages/planning.aspx'
  SEARCH_BUTTON = 'ctl00$SPWebPartManager1$g_717cf524_fe11_474e_b9ab_cc818a5fede9$ctl00$btnPlanningApplicationSearchSubmitAjax'

  attr_reader :browser

  def initialize
    @browser = Watir::Browser.new :phantomjs
  end

  def get_search_page
    browser.goto URL
    browser.button(name: SEARCH_BUTTON).click
    parse_app_refs
  end

  def next_page
    browser.button(id: 'NextButtonTop').click
  end

  def parse_table
   browser.table(id: 'planningResult').wait_until_present
   browser.table(id: 'planningResult').html
  end

  def parse_app_refs
    a = parse_table.split('a href="').select.each_with_index {|str, i| i.even?}
    links = a[1..a.size].map { |e| e.split('?s=1&amp;r=')[1] }
    array = links.map { |e| e.split('"').first }
    array.join("\n")
  end

end

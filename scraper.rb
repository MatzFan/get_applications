require 'date'
require 'json'

class Scraper

  DELIM = 'href="https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r='
  CURL = 'curl -s -X POST -H "Content-Type: application/json" -d '
  P1 = '{"URL":"https://www.mygov.je//Planning/Pages/Planning.aspx","CommonParameters":"|05|'
  P2 = '||||","SearchParameters":"|1301||||0|All|All|'
  REQ_URL = 'https://www.mygov.je/_layouts/15/PlanningAjaxServices/PlanningSearch.svc/Search'
  HEADER = 'HeaderHTML'
  RESULT = 'ResultHTML'

  attr_reader :year, :page_num, :params

  def initialize(year)
    @year = year.to_s
    @page_num = 1
  end

  def num_apps
    source = page_source_json(1)
    JSON.parse(source)[HEADER].split[8].to_i unless source == ''
  end

  def app_refs_on_page(page_num)
    source = page_source_json(page_num)
    unless source == '' then
      arr = JSON.parse(source)[RESULT].split(DELIM)
      arr[1..-1].map { |e| e.split('">')[0] }.uniq.join('|')
    end
  end

  def date_params
    '01|01|' + year + '|' + '31|12|' + year + '"}'
  end

  def latest_app_num
    source = page_source_json(page_num)
    unless source == '' then
      arr = JSON.parse(source)[RESULT].split(DELIM)
      arr[1..-1].map { |e| e.split('">')[0].split('/')[2].to_i}.sort.last
    end
  end

  def page_source_json(page_num)
    curl = CURL + "'" + P1 + page_num.to_s + P2 + date_params + "' " + REQ_URL
    `#{curl}`
  end

end

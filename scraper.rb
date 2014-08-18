require 'date'
require 'json'

class Scraper

  DELIM = 'href="https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r='
  CURL = 'curl -s -X POST -H "Content-Type: application/json" -d '
  P1 = '{"URL":"https://www.mygov.je//Planning/Pages/Planning.aspx","CommonParameters":"|05|'
  P2 = '||||","SearchParameters":"|1301||||0|All|All|'
  URL = 'https://www.mygov.je/_layouts/PlanningAjaxServices/PlanningSearch.svc/Search'
  HEADER = 'HeaderHTML'
  RESULT = 'ResultHTML'

  attr_reader :year, :page_num, :params

  def initialize(year)
    @year = year.to_s
    @page_num = 1
  end

  def num_apps
    JSON.parse(page_source_json(1))[HEADER].split[8].to_i
  end

  def app_refs_on_page(page_num)
    arr = JSON.parse(page_source_json(page_num))[RESULT].split(DELIM)
    arr[1..-1].map { |e| e.split('">')[0] }.uniq.join('|')
  end

  def date_params
    '01|01|' + year + '|' + '31|12|' + year + '"}'
  end

  def latest_app_num
    arr = JSON.parse(page_source_json(page_num))[RESULT].split(DELIM)
    arr[1..-1].map { |e| e.split('">')[0].split('/')[2].to_i}.sort.last
  end

  def page_source_json(page_num)
    curl = CURL + "'" + P1 + page_num.to_s + P2 + date_params + "' " + URL
    `#{curl}`
  end

end

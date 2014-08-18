require 'date'
require 'json'

class Scraper

  DELIM = 'href=https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r='
  CURL = 'curl -s -X POST -H "Content-Type: application/json" -d '
  PARAMS1 = '{"URL":"https://www.mygov.je//Planning/Pages/Planning.aspx","CommonParameters":"|05|'
  PARAMS2 = '||||","SearchParameters":"|1301||||0|All|All|'
  URL = 'https://www.mygov.je/_layouts/PlanningAjaxServices/PlanningSearch.svc/Search'
  ARRAY = 'MapMarkerArray'

  attr_reader :year, :page_num, :params

  def initialize(year)
    @year = year.to_s
    @page_num = 1
  end

  def num_apps
    JSON.parse(page_source_json(1))['HeaderHTML'].split[8].to_i
  end

  def app_refs_on_page(page_num)
    JSON.parse(page_source_json(page_num))[ARRAY].join('').split(DELIM)[1..10].map { |app| app.split('>')[0] }.join('|')
    # apps = JSON.parse(page_source_json(page_num))[ARRAY].join('').split(DELIM)
    # apps[1..10].map { |app| app.split('>')[0] }
  end

  def date_params
    now = Date.parse(Time.now.to_s)
    start = '01|01|' + year
    _end = '31|12|' + year
    # _end = now.strftime("%d|%m|" + year)
    start + '|' + _end + '"}'
  end

  def latest_app_num
    app_nums = JSON.parse(page_source_json(page_num))[ARRAY].join('').split(DELIM)[1..10].map { |app| app.split('>')[0].split('/')[2].to_i}
    app_nums.sort.last.to_s
  end

  def page_source_json(page_num)
    params = PARAMS1 + page_num.to_s + PARAMS2
    curl = CURL + "'" + params + date_params + "' " + URL
    `#{curl}`
  end

end

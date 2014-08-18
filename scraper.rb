require 'date'
require 'json'

class Scraper

  DELIM = 'href=https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r='
  CURL = 'curl -s -X POST -H "Content-Type: application/json" -d '
  PARAMS1 = '{"URL":"https://www.mygov.je//Planning/Pages/Planning.aspx","CommonParameters":"|05|'
  PARAMS2 = '||||","SearchParameters":"|1301||||0|All|All|'
  URL = 'https://www.mygov.je/_layouts/PlanningAjaxServices/PlanningSearch.svc/Search'
  ARRAY = 'MapMarkerArray'

  attr_reader :year, :page_num

  def initialize(year)
    @year = year.to_s
    @page_num = 1
  end

  def num_apps
    JSON.parse(page_json(1))['HeaderHTML'].split[8]
  end

  def date_params
    now = Date.parse(Time.now.to_s)
    start = '01|01|' + year
    _end = '31|12|' + year
    # _end = now.strftime("%d|%m|" + year)
    start + '|' + _end + '"}'
  end

  def latest_app_num
    apps_json = page_json(page_num)
    array = JSON.parse(apps_json)[ARRAY]
    apps_array = array.join('').split(DELIM)
    # app_nums = apps_array[1..10].map {|app| app.split('>')[0].split('/')[2].to_i}
    # app_nums.sort.last.to_s
  end

  def page_json(page_num)
    curl_command = CURL + "'" + PARAMS1 + page_num.to_s + PARAMS2 + date_params + "' " + URL
    `#{curl_command}`
  end

end

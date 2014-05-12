require 'sinatra'
require 'date'
require 'json'

DELIM = 'href=https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r='
CURL = 'curl -s -X POST -H "Content-Type: application/json" -d '
PARAMS = '{"URL":"https://www.mygov.je//Planning/Pages/Planning.aspx","CommonParameters":"|05|1||||","SearchParameters":"|1301||||0|All|All|'
URL = 'https://www.mygov.je/_layouts/PlanningAjaxServices/PlanningSearch.svc/Search'

def date_params # set date params to 12-13 month range
  now = Date.parse(Time.now.to_s)
  start = "01" + (now << 12).strftime("|%m|%Y|")
  _end = now.strftime("%d|%m|%Y")
  start + _end + '"}'
end

def latest_app_num
  curl_command = CURL + "'" + PARAMS + date_params + "' " + URL # note space before URL
  apps_json = `#{curl_command}`
  my_hash = JSON.parse(apps_json)
  array = my_hash['MapMarkerArray']
  apps_array = array.join('').split(DELIM)
  app_nums = apps_array[1..10].map {|app| app.split('>')[0].split('/')[2].to_i}
  app_nums.sort.last.to_s
end

get '/' do
  latest_app_num
end

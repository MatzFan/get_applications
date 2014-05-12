require 'sinatra'
require 'json'

DELIM = 'href=https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r='
CURL = 'curl -s -X POST -H "Content-Type: application/json" -d '
PARAMS = '{"URL":"https://www.mygov.je//Planning/Pages/Planning.aspx","CommonParameters":"|05|1||||","SearchParameters":"|1301||||0|All|All|8|2|2014|8|5|2014"}'
URL = 'https://www.mygov.je/_layouts/PlanningAjaxServices/PlanningSearch.svc/Search'
CURL_COMMAND = CURL + "'" + PARAMS + "' " + URL # note space before URL

def get_latest_app_num
  apps_json = `#{CURL_COMMAND}`
  my_hash = JSON.parse(apps_json)
  array = my_hash['MapMarkerArray']
  apps_array = array.join('').split(DELIM)
  app_nums = apps_array[1..10].map {|app| app.split('>')[0].split('/')[2].to_i}
  latest_app_num = app_nums.sort.last.to_s
end

get '/' do
  get_latest_app_num
end

require 'sinatra'
require 'json'

delim = "href=https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r="
apps_json =`curl -s -X POST -H "Content-Type: application/json" -d '{"URL":"https://www.mygov.je//Planning/Pages/Planning.aspx","CommonParameters":"|05|1||||","SearchParameters":"|1301||||0|All|All|8|2|2014|8|5|2014"}' https://www.mygov.je/_layouts/PlanningAjaxServices/PlanningSearch.svc/Search`
my_hash = JSON.parse(apps_json)
array = my_hash['MapMarkerArray']
apps_array = array.join('').split('href=https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r=')
app_nums = apps_array[1..10].map { |app| app.split('>')[0].split('/')[2].to_i }
latest_app_num = app_nums.sort.reverse.first.to_s

get '/' do
  latest_app_num
end

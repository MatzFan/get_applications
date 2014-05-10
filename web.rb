require 'sinatra'

delim = "href=https://www.mygov.je//Planning/Pages/PlanningApplicationDetail.aspx?s=1&amp;r="
apps_text =`curl -s -X POST -H "Content-Type: application/json" -d '{"URL":"https://www.mygov.je//Planning/Pages/Planning.aspx","CommonParameters":"|05|1||||","SearchParameters":"|1301||||0|All|All|8|2|2014|8|5|2014"}' https://www.mygov.je/_layouts/PlanningAjaxServices/PlanningSearch.svc/Search|jsawk 'return this.MapMarkerArray'`
array = apps_text.split(delim)
apps = ''
for i in 1..10 do
  apps += array[i].split('>')[0]+"|"
end

get '/' do
  apps
end

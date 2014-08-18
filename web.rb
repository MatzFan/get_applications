require 'sinatra'
require './scraper'

get '/' do
  # Scraper.new(2014).latest_app_num
  Scraper.new(2014).num_apps
end

# get '/refs' do
#   Scraper.new.get_search_page
# end

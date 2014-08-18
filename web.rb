require 'sinatra'
require './scraper'

get '/' do
  Scraper.new(2013).latest_app_num
end

# get '/refs' do
#   Scraper.new.get_search_page
# end

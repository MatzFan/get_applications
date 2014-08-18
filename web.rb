require 'sinatra'
require './curler'
require './scraper'

get '/' do
  Curler.new.latest_app_num
end

get '/refs' do
  Scraper.new.get_search_page
end

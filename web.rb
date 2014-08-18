require 'sinatra'
require './scraper'

get '/' do
  Scraper.new(2014).latest_app_num
end

get '/app_refs_for' do
  year = params[:year]
  page_num = params[:page_num]
  Scraper.new(year).app_refs_on_page(page_num)
end

# get '/refs' do
#   Scraper.new.get_search_page
# end

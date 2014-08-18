require 'sinatra'
require './scraper'

# get '/' do
#   Scraper.new(2014).latest_app_num
# end

get '/num_apps_for' do
  year = params[:year]
  Scraper.new(year).num_apps.to_s
end

get '/app_refs_for' do
  year = params[:year]
  page_num = params[:page_num]
  Scraper.new(year).app_refs_on_page(page_num)
end

get '/' do
  source = Scraper.new(1988).page_source_json(1)
end

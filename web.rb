require 'sinatra'
require 'gon-sinatra'
require './scraper'
require './mechanizer'

Sinatra::register Gon::Sinatra

get '/' do
  Scraper.new(2014).latest_app_num.to_s
end

get '/num_apps_for' do
  year = params[:year]
  Scraper.new(year).num_apps.to_s
end

get '/app_refs_for' do
  year = params[:year]
  page_num = params[:page_num]
  Scraper.new(year).app_refs_on_page(page_num)
end

get '/location_plan' do
  content_type 'application/pdf'
  app_ref = params[:ref]
  File.open(Mechanizer.new(app_ref).get_pdf.save)
end

get '/map' do
  gon.plot_locations = [[49.178609, -2.224561],[49.179508, -2.225726], [49.199063, -2.111496]]
  gon.plot_descriptions = ['green', 'red', 'orange']
  erb :map
end

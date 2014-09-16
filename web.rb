require 'sinatra'
require 'gon-sinatra'
require './scraper'
require './mechanizer'
require './doc_scraper'
require './pdf_reader'

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

post '/map' do
  gon.plot_locations = params[:coords].split('|').map { |e| e.split(',')}
  gon.plot_icon_colours = params[:colours].split('|')
  gon.plot_categories = params[:categories].split('|')
  gon.plot_titles = params[:refs].split('|')
  gon.plot_descriptions = params[:descriptions].split('|')
  erb :map
end

get '/meetings' do
  DocScraper.new.meetings.join("\n")
end

get '/documents' do
  DocScraper.new.documents.join("\n")
end

get '/doc_app_refs' do
  file = URI.encode(params[:file])
  reader = PdfReader.new(file)
  reader.download
  reader.app_refs.join("\n")
end

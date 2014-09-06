require './web.rb'
run Sinatra::Application

configure do
  set :protection, except: [:frame_options]
end

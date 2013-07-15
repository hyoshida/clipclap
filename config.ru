# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
#run Clipclap::Application

map ActionController::Base.config.relative_url_root || "/" do
  run Clipclap::Application
end

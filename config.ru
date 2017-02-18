# This file is used by Rack-based servers to start the application.

# Rails config - needed for bot as well
require ::File.expand_path('../config/environment', __FILE__)

if ENV['APP'] == 'bot'
  require ::File.expand_path('../bot/commands/squash', __FILE__)

  Mongoid.load!(File.expand_path('../config/mongoid.yml', __FILE__), ENV['RACK_ENV'])
  SlackRubyBotServer::App.instance.prepare!

  SlackRubyBotServer::Service.start!
  run SlackRubyBotServer::Api::Middleware.instance
else
  run Rails.application
end

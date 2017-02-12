# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
require ::File.expand_path('../bot/bot', __FILE__)
require ::File.expand_path('../bot/commands/calculate', __FILE__)
require ::File.expand_path('../bot/commands/squash', __FILE__)

Thread.abort_on_exception = true
Thread.new do
  EyBot::Bot.run
end

run Rails.application

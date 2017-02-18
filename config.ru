# This file is used by Rack-based servers to start the application.

# Rails config - needed for bot as well
require ::File.expand_path('../config/environment', __FILE__)

run Rails.application

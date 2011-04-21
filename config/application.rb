require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'mongoid/railtie'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Datajam
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.middleware.insert_before 'ActionDispatch::Static', 'Rack::RedisCache'
  end
end

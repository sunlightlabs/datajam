require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'mongoid/railtie'
require 'rack/gridfs'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Datajam
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.middleware.insert 0, 'Rack::RedisCache'
    config.middleware.insert 1, 'Rack::GridFS', :prefix => 'static',
                                   :lookup => :path, :database => "datajam_#{Rails.env}"
  end
end

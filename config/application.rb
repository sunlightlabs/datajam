require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'mongoid/railtie'
require 'rack/gridfs'
require 'csv'

require File.expand_path('../../lib/plugins_loader', __FILE__)

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Datajam
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.autoload_paths += %W(#{Rails.root}/lib)
    config.middleware.insert 0, 'Rack::Deflater'
    config.middleware.insert 1, 'Rack::RedisCache'
    config.middleware.insert_before('Rack::Lock', 'Rack::Rewrite') do
      r301 %r{(.+)/$}, '$1'
    end
    config.action_view.javascript_expansions[:defaults] = %w(
      http://cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js
      http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7/jquery.min.js
      http://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js
      http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.2.1/underscore-min.js
      http://cdnjs.cloudflare.com/ajax/libs/backbone.js/0.5.3/backbone-min.js
      http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.0.2/bootstrap.min.js
      http://cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.0.0.beta2/handlebars.min.js
      rails.js
      jquery.pjax.js
      jquery.autoSuggest.js
    )
  end
  def self.setup
    yield self if block_given?
  end
end

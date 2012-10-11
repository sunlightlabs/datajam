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
    config.after_initialize do
      Datajam::Application.routes.append{match '*path', :to => 'content#error_404'}
    end
    config.action_view.javascript_expansions[:admin] = %w(
      //cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js
      //cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.3/underscore-min.js
      //cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.0.2/bootstrap.min.js
      libs/rails.js
      libs/jquery.pjax.js
      libs/jquery.autoSuggest.js
      //cdnjs.cloudflare.com/ajax/libs/ace/0.2.0/ace.js
      libs/ace/mode-html.js
      admin.js
    )
    config.action_view.javascript_expansions[:head] = %w(
      //cdnjs.cloudflare.com/ajax/libs/modernizr/2.6.1/modernizr.min.js
      //cdnjs.cloudflare.com/ajax/libs/jquery/1.7/jquery.min.js

    )
    config.action_view.javascript_expansions[:body] = %w(
      //cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js
      //cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.3/underscore-min.js
      //cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.0.0.beta6/handlebars.min.js
      //cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.0.2/bootstrap.min.js
      //cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.2/backbone-min.js
      //cdnjs.cloudflare.com/ajax/libs/require.js/2.0.6/require.min.js
      libs/rails.js
    )
    config.action_view.stylesheet_expansions[:admin] = %w(
      //netdna.bootstrapcdn.com/twitter-bootstrap/2.1.0/css/bootstrap.no-icons.min.css
      //netdna.bootstrapcdn.com/font-awesome/2.0/css/font-awesome.css
      admin.css
      autoSuggest.css

    )
    config.action_view.stylesheet_expansions[:user] = %w(
      application.css
    )
  end
  def self.setup
    yield self if block_given?
  end
end

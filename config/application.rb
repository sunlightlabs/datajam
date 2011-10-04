require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'mongoid/railtie'
require 'rack/gridfs'

Bundler.require(:default, Rails.env) if defined?(Bundler)

# Allow datajam_* engines to override Datajam core classes
require 'active_support/dependencies'
module ActiveSupport::Dependencies
  alias_method :require_or_load_without_multiple, :require_or_load
  def require_or_load(file_name, const_path = nil)
    require_or_load_without_multiple(file_name, const_path)
    if file_name.starts_with?(Rails.root.to_s + '/app')
      relative_name = file_name.gsub(Rails.root.to_s, '')
      @engine_paths ||= Rails::Application::Railties.engines.collect{|engine| engine.config.root.to_s }
      @datajam_engine_paths ||= @engine_paths.reject{ |path| path.split('/').last.match(/^datajam_/).blank? }
      @datajam_engine_paths.each do |path|
        engine_file = File.join(path, relative_name)
        require_or_load_without_multiple(engine_file, const_path) if File.file?(engine_file)
      end
    end
  end
end

module Datajam
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.middleware.insert 0, 'Rack::RedisCache'
    config.middleware.insert 1, 'Rack::GridFS', :prefix => 'static',
                                   :lookup => :path, :database => "datajam_#{Rails.env}"
  end
end

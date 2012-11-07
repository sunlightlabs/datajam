require 'renders_templates'

class RendersTemplates::DummyController < AbstractController::Base
  include AbstractController::Rendering
  include AbstractController::Layouts
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include AbstractController::Logger
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  helper ApplicationHelper

  self.view_paths = ["#{Rails.root}/app/views"].tap do |paths|
    ActiveSupport::Dependencies.plugins_loader.engine_paths.each do |path|
        paths << "#{path}/app/views"
    end
  end
  self.assets_dir = "#{Rails.root}/public"
  self.javascripts_dir = "#{self.assets_dir}/javascripts"
  self.javascripts_dir = "#{self.assets_dir}/stylesheets"

  def _render(args=nil)
    render_to_string args
  end

  def params
    {}
  end

end
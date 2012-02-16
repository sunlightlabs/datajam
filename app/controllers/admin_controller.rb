class AdminController < ApplicationController

  before_filter :authenticate_user!

  def index

  end

  def plugins
    @plugins = Datajam.plugins.sort {|x,y| x.name <=> y.name }
  end

  def plugin_settings
    if request.post? or request.put?
      batch = Setting.bulk_update(params[:settings])
      if batch[:updated]
        flash[:notice] = 'Settings updated.'
      else
        flash[:error] = 'There was an error updating one or more settings.'
      end
    end

    klass = params[:name].classify.constantize

    @plugin = Datajam.plugins.find {|plugin| plugin.name == params[:name] }
    raise ActionController::RoutingError.new('Not Found') unless @plugin

    @settings = Setting.where(:namespace => params[:name]).order_by([:name, :asc])

    @actions = klass::PluginController.action_methods rescue []
    # controller methods starting with '_' are not linked in settings page
    @actions.reject! {|method| method.to_s =~ /^_/ }
    # don't show install link if plugin is installed
    @actions.reject! {|method| @settings.any? && method == 'install' }
    # only show install link if plugin isn't installed, and installation is required
    @actions.reject! {|method| @settings.empty? && klass.install_required? && method != 'install' }
    # remove 'installed' setting after checking for installation; it's only used to determine status
    @settings.reject! {|setting| setting[:name] == 'installed' }

    render 'admin/plugin_settings'
  end

end

class Admin::PluginsController < AdminController
  def index
    @plugins = Datajam.plugins.sort {|x,y| x.name <=> y.name }
  end

  def show
    @plugin = Datajam.plugins.find {|plugin| plugin.name == params[:id] }
    raise ActionController::RoutingError.new('Not Found') unless @plugin

    klass_path = @plugin.name.split('-').map { |part| part.classify }
    klass = klass_path.join('::').constantize

    @settings = Setting.where(:namespace => params[:id]).order_by([:name, :asc])

    @actions = klass::PluginController.action_methods.to_a rescue []
    # controller methods starting with '_' are not linked in settings page
    @actions.reject! {|method| method.to_s =~ /^_/ }
    # don't show install link if plugin is installed
    @actions.reject! {|method| @settings.any? && method == 'install' }
    # only show install link if plugin isn't installed, and installation is required
    @actions.reject! {|method| @settings.empty? && klass.install_required? && method != 'install' }
    @actions.sort!

    # remove 'installed' setting after checking for installation; it's only used to determine status
    @settings.reject! {|setting| setting[:name] == 'installed' }
  end

  def update
    batch = Setting.bulk_update(params[:settings])
    if batch[:updated]
      flash[:success] = 'Settings updated.'
    else
      flash[:error] = 'There was an error updating one or more settings.'
    end
    redirect_to admin_plugin_path params[:id]
  end
end

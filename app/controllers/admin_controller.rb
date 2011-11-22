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

    @plugin = Datajam.plugins.find {|plugin| plugin.name == params[:name] }
    raise ActionController::RoutingError.new('Not Found') unless @plugin

    @settings = Setting.where(:namespace => params[:name]).order_by([:name, :asc])

    render 'admin/plugin_settings'
  end

end

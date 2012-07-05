module PluginsHelper
    def action_controller_for(plugin)
        plugin.name.split('-').join('/') + '/plugin'
    end
end
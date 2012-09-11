class Admin::SettingsController < AdminController
    def index
        @settings = Setting.where(:namespace => 'datajam')
                           .order_by([:name, :asc]).reject do |setting|
            setting.name =~ /^_/
        end
    end

    def update
    batch = Setting.bulk_update(params[:settings])
    if batch[:updated]
      flash[:success] = 'Settings updated.'
    else
      flash[:error] = 'There was an error updating one or more settings.'
    end
    redirect_to :back
    end
end
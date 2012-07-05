Datajam::Application.routes.draw do

  devise_for :users

  match 'admin' => 'admin#index', :as => 'admin_root'
  match 'admin/check' => 'admin#check'
  # match 'admin/plugins/:name' => 'admin#plugin_settings', :as => 'plugin_settings'
  # match 'admin/plugins' => 'admin#plugins'
  namespace :admin do
    resources :assets
    resources :users
    resources :tags, only: [:index, :update, :destroy, :create]
    resources :events do
      member do
        put :finalize, :reopen
      end
      resources :reminders, :only => :destroy
    end
    resources :pages
    resources :cards
    resources :templates
    resources :plugins, :only => [:index, :show, :update]
    resources :cache, :only => [:index] do
      get 'rebuild', :on => :collection
    end

    resources :site_templates, :controller => 'templates/site', :type => SiteTemplate, :as => 'templates_site'
    resources :event_templates, :controller => 'templates', :type => EventTemplate, :as => 'templates_event'
    resources :embed_templates, :controller => 'templates', :type => EmbedTemplate, :as => 'templates_embed'
  end

  resources :reminders, :only => [:create]

  match 'onair/signed_in' => 'onair#signed_in'
  match 'onair/update' => 'onair#update', :via => [:post]

  mount Rack::GridFS::Endpoint.new(:db => Mongoid.database, :lookup => :path, :expires => 604800), :at => "static"

  root :to => 'content#index'

end

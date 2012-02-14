Datajam::Application.routes.draw do

  devise_for :users

  match 'admin' => 'admin#index'
  match 'admin/check' => 'admin#check'
  match 'admin/plugins/:name' => 'admin#plugin_settings', :as => 'plugin_settings'
  match 'admin/plugins' => 'admin#plugins'
  namespace :admin do
    resources :assets
    resources :users
    resources :events
    resources :pages
    resources :cards
    namespace :templates do
      resource :site, :controller => 'site'
      resources :events
      resources :embeds
    end
  end

  match 'onair/signed_in' => 'onair#signed_in'
  match 'onair/update' => 'onair#update', :via => [:post]

  mount Rack::GridFS::Endpoint.new(:db => Mongoid.database, :lookup => :path, :expires => 604800), :at => "static"

  root :to => 'content#index'

end

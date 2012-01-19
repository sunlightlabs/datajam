Datajam::Application.routes.draw do

  devise_for :users

  match 'admin' => 'admin#index'
  match 'admin/check' => 'admin#check'
  match 'admin/plugins' => 'admin#plugins'
  match 'admin/plugins/:name' => 'admin#plugin_settings', :as => 'plugin_settings'
  namespace :admin do
    resources :assets
    resources :users
    resources :events
    resources :cards
    namespace :templates do
      resource :site, :controller => 'site'
      resources :events
      resources :embeds
    end
  end

  match 'onair/signed_in' => 'onair#signed_in'
  match 'onair/update' => 'onair#update', :via => [:post]

  root :to => 'content#index'

end

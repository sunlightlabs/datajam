Datajam::Application.routes.draw do

  devise_for :users

  match 'admin' => 'admin#index'
  match 'admin/plugins' => 'admin#plugins'
  namespace :admin do
    resources :assets
    resources :users
    resources :events
    namespace :templates do
      resource :site, :controller => 'site'
      resources :events
      resources :embeds
    end
  end
  root :to => "content#index"

end

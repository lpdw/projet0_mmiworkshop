Rails.application.routes.draw do
  resources :dashboard
  resources :workshops
  devise_for :users
  resources :projects do
    collection do
      get 'synthesis'
      get 'stats'
    end
  end
  get 'projects/:id/stats' => 'projects#stats'
  get 'users/me' => 'users#me', as: 'my_profile'
  patch 'users/me' => 'users#update_me', as: 'update_my_profile'
  resources :users
  get 'users/diploma/:year' => 'users#diploma', as: 'users_by_diploma'
  resources :features do
    collection do
      get 'synthesis'
    end
  end
  resources :fields
  root 'features#index'
  get 'get_feature_id' => 'features#get_feature_id'
  get 'autocomplete_feature' => 'features#autocomplete_feature'
end

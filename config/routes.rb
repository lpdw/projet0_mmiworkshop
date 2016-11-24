Rails.application.routes.draw do
  root :to => "dashboard#index"
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
  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end
  resources :users
  get 'users/diploma/:year' => 'users#diploma', as: 'users_by_diploma'
  resources :features do
    collection do
      get 'synthesis'
    end
  end
  resources :fields
  get 'autocomplete_feature' => 'projects#autocomplete_feature'
  get 'get_add_from_list_modal' => 'projects#get_add_from_list_modal'
  post "projects/:id" => "projects#assignUserToProject"
end

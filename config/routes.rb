Rails.application.routes.draw do
  get 'profile/index'

  get 'agents', to: 'agents#index'
  get 'agents/new', to: 'agents#new', as: 'new_agent'
  post 'agents/create', to: 'agents#create', as: 'create_agent'

  get 'agents/show/:user_id', to: 'agents#show', as: 'show_agent'
  post 'agents/edit/:user_id', to: 'agents#edit', as: 'edit_agent'

  get 'agents/assign_client/:user_id', to: 'agents#assign_client', as: 'assign_client'
  post 'agents/create_assignation/', to: 'agents#create_assignation', as: 'create_assignation'

  match '/search_brokers', to: 'pages#search_brokers', as: 'search_brokers', via: [:get, :post]
  
  get 'clients/refer_broker/:user_id', to: 'clients#refer_broker', as: 'refer_broker'
  
  get 'clients/refer_agent/:user_id', to: 'clients#refer_agent', as: 'refer_agent'
  
  get 'clients/assign_broker/:user_id', to: 'clients#assign_broker', as: 'assign_broker'
  post 'clients/change_broker/:user_id', to: 'clients#change_broker', as: 'change_broker'


  post 'clients/create_referral/', to: 'clients#create_referral', as: 'create_referral'

  get 'clients', to: 'clients#index'
  get 'clients/new', to: 'clients#new', as: 'new_client'
  post 'clients/create_client', to: 'clients#create_client', as: 'create_client'

  get 'clients/show/:user_id', to: 'clients#show', as: 'show_client'
  post 'clients/update_client/:user_id', to: 'clients#update_client', as: 'update_client'

  get 'clients/edit/:user_id', to: 'clients#edit', as: 'edit_client'
  get 'update_agent/:id', to: 'agents#update', as: 'update_agents'
  
  post 'profile/update_profile', to: 'profile#update_profile', as: 'update_profile'
  devise_for :users
  get 'brokers_locations', to: 'pages#get_brokers_locations', as: 'brokers_locations'
  root 'pages#home'

  post 'get_states_by_country/:country_id', to: 'pages#get_states_by_country'

  post 'get_cities_by_country_and_state/:country/:state_id', to: 'pages#get_cities_by_country_and_state'

  get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  
  get 'dashboard/show_user/:user_id', to: 'dashboard#show_user', as: 'show_user'

  post 'dashboard/edit_user/:user_id', to: 'dashboard#edit_user', as: 'edit_user'

  get 'transactions', to: 'transactions#index', as: 'transactions'

  get 'remove_user/:user_id', to: 'dashboard#remove_user', as: 'remove_user'

  match "clients/refer_client_from_broker", to: "clients#refer_client_from_broker", as: 'refer_client_from_broker', via: [:get, :post]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

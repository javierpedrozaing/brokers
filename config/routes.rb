Rails.application.routes.draw do
  get 'profile/index'

  get 'agents', to: 'agents#index'
  get 'agents/new', to: 'agents#new', as: 'new_agent'
  post 'agents/create', to: 'agents#create', as: 'create_agent'

  match 'agents/assign_client', to: 'agents#assign_client', as: 'assign_client', via: [:get, :post]
  
  get 'clients/refer_agent/:user_id', to: 'clients#refer_agent', as: 'refer_agent'
  post 'clients/create_referral/', to: 'clients#create_referral', as: 'create_referral'

  get 'clients', to: 'clients#index'
  get 'clients/new', to: 'clients#new', as: 'new_client'
  post 'clients/create', to: 'clients#create', as: 'create_client'


  get 'update_client/:id', to: 'clients#update', as: 'update_clients'
  get 'update_agent/:id', to: 'agents#update', as: 'update_agents'
  
  post 'profile/update_profile', to: 'profile#update_profile'
  devise_for :users
  get 'brokers_locations', to: 'pages#get_brokers_locations', as: 'brokers_locations'
  get '/', to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

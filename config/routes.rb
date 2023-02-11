Rails.application.routes.draw do
  get 'profile/index'

  get 'agents', to: 'agents#index'
  get 'agents/new', to: 'agents#new', as: 'new_agent'
  post 'agents/create', to: 'agents#create', as: 'create_agent'

  get 'agents/assign_client/:user_id', to: 'agents#assign_client', as: 'assign_client'
  post 'agents/create_assignation/', to: 'agents#create_assignation', as: 'create_assignation'
  
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

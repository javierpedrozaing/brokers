Rails.application.routes.draw do
  get 'profile/index'
  get 'clients', to: 'clients#index'
  get 'agents', to: 'agents#index'

  get 'update_client/:id', to: 'clients#update', as: 'update_clients'
  get 'update_agent/:id', to: 'agents#update', as: 'update_agents'
  
  post 'profile/update_profile', to: 'profile#update_profile'
  devise_for :users
  get 'brokers_locations', to: 'pages#get_brokers_locations', as: 'brokers_locations'
  get '/', to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  get 'profile/index'
  post 'profile/update', 'profile#update'
  devise_for :users
  get '/', to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  root to: 'pages#home'
  post 'login_register', to: 'pages#login_register'

  resources :movies, only: %w[new create]

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

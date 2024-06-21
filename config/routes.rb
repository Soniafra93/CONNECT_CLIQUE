Rails.application.routes.draw do
  devise_for :users
  resources :activities do
    resources :votes, only: [:new, :create]
    post 'close_voting', on: :member
  end
  resources :friends, only: [:index, :create, :destroy]
  resources :activities do
    resources :attendances
  end

  resources :activities do
    post 'vote', on: :member
    post 'close_voting', on: :member
  end
  root 'pages#home'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

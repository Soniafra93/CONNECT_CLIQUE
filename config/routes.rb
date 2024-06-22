Rails.application.routes.draw do
  devise_for :users

  resources :activities do
    resources :votes, only: [:create, :new]
    post 'close_voting', on: :member
    resources :attendances, only: [:index, :create, :new, :edit, :show, :update, :destroy]
  end
  resources :friends, only: [:index, :create, :destroy, :show]
  root 'pages#home'
  get '/up', to: 'rails/health#show'
end

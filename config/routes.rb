Rails.application.routes.draw do
  devise_for :users

  get 'notifications/index'
  get 'notifications/mark_as_read'

  post 'friends', to: 'friends#new_friend', as: 'new_friend'
  resources :activities do
    member do
      post 'close_voting'
    end
    resources :votes, only: [:create, :new]
    resources :attendances, only: [:index, :create, :new, :edit, :show, :update, :destroy]
  end

  resources :friends, only: [:index, :create, :destroy]



  root 'pages#home'
  get '/up', to: 'rails/health#show'


  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end
end

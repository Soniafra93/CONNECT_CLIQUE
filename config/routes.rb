Rails.application.routes.draw do
  devise_for :users

  get 'notifications/index'
  get 'notifications/mark_as_read'
  get 'myprofile', to: 'pages#myprofile', as: 'my_profile'

  resources :activities do
    member do
      post 'close_voting'
    end
    resources :votes, only: [:create, :new]
    resources :attendances, only: [:index, :create, :new, :edit, :show, :update, :destroy]
  end

  resources :friends, only: [:index, :create, :destroy, :show]

  root 'pages#home'
  get '/up', to: 'rails/health#show'


  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end
end
